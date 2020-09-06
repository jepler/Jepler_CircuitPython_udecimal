import unittest
import doctest
import jepler_udecimal
import jepler_udecimal.utrig

def load_tests(loader, tests, ignore):
    tests.addTests(doctest.DocTestSuite(jepler_udecimal))
    tests.addTests(doctest.DocTestSuite(jepler_udecimal.utrig))
    return tests

if __name__ == '__main__':
    unittest.main()
