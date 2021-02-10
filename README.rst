Introduction
============

.. image:: https://readthedocs.org/projects/jepler-udecimal/badge/?version=latest
    :target: https://jepler-udecimal.readthedocs.io/en/latest/
    :alt: Documentation Status

.. image:: https://img.shields.io/discord/327254708534116352.svg
    :target: https://adafru.it/discord
    :alt: Discord

.. image:: https://github.com/jepler/Jepler_CircuitPython_udecimal/workflows/Build%20CI/badge.svg
    :target: https://github.com/jepler/Jepler_CircuitPython_udecimal/actions
    :alt: Build Status

.. image:: https://img.shields.io/badge/code%20style-black-000000.svg
    :target: https://github.com/psf/black
    :alt: Code Style: Black

Reduced version of the decimal library for CircuitPython


Dependencies
=============
This library depends on:

* `Adafruit CircuitPython <https://github.com/adafruit/circuitpython>`_

The library also runs on desktop Python3, and should give numerically identical
results across all platorms.

Installing from PyPI
=====================

To install for current user:

.. code-block:: shell

    python3 -mpip install --user jepler-circuitpython-udecimal

To install system-wide (this may be required in some cases):

.. code-block:: shell

    sudo python3 -mpip install jepler-circuitpython-udecimal

To install in a virtual environment in your current project:

.. code-block:: shell

    mkdir project-name && cd project-name
    python3 -m venv .env
    source .env/bin/activate
    pip3 install jepler-circuitpython-udecimal

Usage Example
=============

.. code-block:: python

    >>> from jepler_udecimal import Decimal
    >>> Decimal(2)/3
    Decimal('0.6666666666666666666666666667')
    >>> Decimal('.1') + Decimal('.2') == Decimal('.3')
    True


Contributing
============

Contributions are welcome! Please read our `Code of Conduct
<https://github.com/jepler/Jepler_CircuitPython_udecimal/blob/master/CODE_OF_CONDUCT.md>`_
before contributing to help this project stay welcoming.

Documentation
=============

For information on building library documentation, please check out `this guide <https://learn.adafruit.com/creating-and-sharing-a-circuitpython-library/sharing-our-docs-on-readthedocs#sphinx-5-1>`_.
