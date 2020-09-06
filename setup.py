# SPDX-FileCopyrightText: 2017 Scott Shawcroft, written for Adafruit Industries
# SPDX-FileCopyrightText: Copyright (c) 2020 jepler for Unpythonic Networks
#
# SPDX-License-Identifier: MIT

"""A setuptools based setup module.

See:
https://packaging.python.org/en/latest/distributing.html
https://github.com/pypa/sampleproject
"""

from setuptools import setup, find_packages

# To use a consistent encoding
from codecs import open
from os import path

here = path.abspath(path.dirname(__file__))

# Get the long description from the README file
with open(path.join(here, "README.rst"), encoding="utf-8") as f:
    long_description = f.read()

setup(
    name="jepler-circuitpython-udecimal",
    use_scm_version=True,
    setup_requires=["setuptools_scm"],
    description="Reduced version of the decimal library for CircuitPython",
    long_description=long_description,
    long_description_content_type="text/x-rst",
    # The project's main homepage.
    url="https://github.com/jepler/Jepler_CircuitPython_udecimal",
    # Author details
    author="Jeff Epler",
    author_email="jepler@gmail.com",
    install_requires=[],
    # Choose your license
    license="MIT",
    # See https://pypi.python.org/pypi?%3Aaction=list_classifiers
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "Topic :: Software Development :: Libraries",
        "Topic :: System :: Hardware",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.4",
        "Programming Language :: Python :: 3.5",
    ],
    # What does your project relate to?
    keywords="adafruit blinka circuitpython micropython udecimal numeric helper "
    "arbitraryprecision math",
    # You can just specify the packages manually here if your project is
    # simple. Or you can use find_packages().
    packages=["jepler_udecimal"],
)
