#!/bin/bash
set -eo pipefail

repo_name=`git config remote.origin.url | sed -e 's,^.*/,,;s/\.git$//' | tr A-Z_ a-z-`
echo "=== Building package: $repo_name"

echo "=== Create and set up virtual environment"
[ -d .venv ] || python3 -m venv .env
. .env/bin/activate
echo "=== Install requirements"
pip3 install wheel
pip3 install -r requirements_dev.txt
echo "=== Run pre-commit"
pre-commit run --all-files

echo "=== Clone and build circuitpython unix port"
[ -e circuitpython/py/py.mk ] || git clone --shallow-since=2021-07-01 https://github.com/adafruit/circuitpython
[ -e circuitpython/lib/libffi/autogen.sh ] || (cd circuitpython && git submodule update --init lib/libffi lib/axtls lib/berkeley-db-1.xx tools/huffman lib/uzlib extmod/ulab)
[ -x circuitpython/ports/unix/micropython ] || (
make -C circuitpython/mpy-cross -j$(nproc)
make -C circuitpython/ports/unix -j$(nproc) deplibs
make -C circuitpython/ports/unix -j$(nproc) DEBUG=1 STRIP=:
)

echo "=== Run tests"
python -m jepler_udecimal.test

run-tests () {
    env MICROPYPATH=. PYTHONPATH=. MICROPY_MICROPYTHON=circuitpython/ports/unix/micropython circuitpython/tests/run-tests.py "$@"
}

run-tests --clean-failures
if ! run-tests -d examples; then
    run-tests --print-failures
    exit 1
fi

PYTHONPATH=. python examples/test_udecimal.py > test_udecimal.exp
echo "=== Build CircuitPython bundle"
circuitpython-build-bundles --package_folder_prefix jepler --filename_prefix $repo_name --library_location .

echo "=== Build docs"
rm -rf docs/_build
(cd docs && sphinx-build -E -W -b html . _build/html)

echo "=== Build pypi files"
python setup.py sdist
python setup.py bdist_wheel --universal

echo "=== Check pypi files"
twine check dist/*
# SPDX-FileCopyrightText: Copyright (c) 2020 jepler for Unpythonic Networks
#
# SPDX-License-Identifier: MIT
