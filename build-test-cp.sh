#!/bin/sh
# SPDX-FileCopyrightText: 2022 Jeff Epler
# SPDX-License-Identifier: MIT
# SPDX-License-Identifier: Unlicense

set -e
TAG=8.0.0-beta.4
if ! [ -e circuitpython/py/py.mk ]; then
    git clone -b $TAG --depth=1 https://github.com/adafruit/circuitpython
fi

(cd circuitpython && git submodule update --init lib/libffi lib/axtls lib/berkeley-db-1.xx tools/huffman extmod/ulab)

if ! [ -x circuitpython/ports/unix/micropython ]; then
    make -C circuitpython/ports/unix -j$(nproc) DEBUG=1 STRIP=:
fi

if ! MICROPYPATH=. PYTHONPATH=. MICROPY_MICROPYTHON=circuitpython/ports/unix/micropython circuitpython/tests/run-tests.py -d examples; then
    circuitpython/tests/run-tests.py --print-failures
    exit 1
fi
