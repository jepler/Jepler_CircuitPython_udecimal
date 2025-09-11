#!/bin/bash
set -eo pipefail

in_section=false
if [ "${CI}" -eq "true" ]; then
    start_section () {
        if $in_section; then end_section; fi
        echo "::group::$*"
        export in_section=true
    }
    end_section () {
        echo "::endgroup::$*"
        in_section=false
    }
else
    start_section () {
        if $in_section; then end_section; fi
        echo "=== $*"
        export in_section=true
    }
    end_section () {
        echo
        in_section=false
    }
fi

repo_name=`git config remote.origin.url | sed -e 's,^.*/,,;s/\.git$//' | tr A-Z_ a-z-`
echo "*** Building package: $repo_name"

start_section "Create and set up virtual environment"
[ -d .venv ] || python3 -m venv .env
. .env/bin/activate
start_section "Install requirements"
pip3 install wheel
pip3 install -r optional_requirements.txt
start_section "Run pre-commit"
pre-commit run --all-files

start_section "Clone and build circuitpython unix port"
[ -e circuitpython/py/py.mk ] || git clone --shallow-since=2021-07-01 https://github.com/adafruit/circuitpython
[ -e circuitpython/lib/libffi/autogen.sh ] || (cd circuitpython && git submodule update --init lib/libffi lib/axtls lib/berkeley-db-1.xx tools/huffman lib/uzlib extmod/ulab)
[ -x circuitpython/ports/unix/micropython ] || (
make -C circuitpython/mpy-cross -j$(nproc)
make -C circuitpython/ports/unix -j$(nproc) deplibs submodules
make -C circuitpython/ports/unix -j$(nproc) DEBUG=1 STRIP=:
)

start_section "Run tests"
python -m jepler_udecimal.test

run_tests () {
    env MICROPYPATH="`readlink -f .`" PYTHONPATH="`readlink -f .`" MICROPY_MICROPYTHON=circuitpython/ports/unix/build-standard/micropython circuitpython/tests/run-tests.py --keep-path "$@"
}

run_tests --clean-failures
if ! run_tests -d examples; then
    run_tests --print-failures
    exit 1
fi

PYTHONPATH=. python examples/test_udecimal.py > test_udecimal.exp
start_section "Build CircuitPython bundle"
circuitpython-build-bundles --package_folder_prefix jepler --filename_prefix $repo_name --library_location .

start_section "Build docs"
rm -rf docs/_build
(cd docs && sphinx-build -E -W -b html . _build/html)

start_section "Build pypi files"
python -m build

start_section "Check pypi files"
twine check dist/*
end_section

echo "=== Success"

# SPDX-FileCopyrightText: Copyright (c) 2020 jepler for Unpythonic Networks
#
# SPDX-License-Identifier: MIT
