# coding: utf-8

"""
    Gene Feature Enumeration Service

    The Gene Feature Enumeration (GFE) Submission service provides an API for converting raw sequence data to GFE. It provides both a RESTful API and a simple user interface for converting raw sequence data to GFE results. Sequences can be submitted one at a time or as a fasta file. This service uses <a href=\"https://github.com/nmdp-bioinformatics/service-feature\">nmdp-bioinformatics/service-feature</a> for encoding the raw sequence data and <a href=\"https://github.com/nmdp-bioinformatics/HSA\">nmdp-bioinformatics/HSA</a> for aligning the raw sequence data. The code is open source, and available on <a href=\"https://github.com/nmdp-bioinformatics/service-gfe-submission\">GitHub</a>.<br><br>Go to <a href=\"http://service-gfe-submission.readthedocs.io\">service-gfe-submission.readthedocs.io</a> for more information

    OpenAPI spec version: 1.0.7
    Contact: mhalagan@nmdp.org
    Generated by: https://github.com/swagger-api/swagger-codegen.git
"""


from __future__ import absolute_import

import os
import sys
import unittest

import swagger_client
from swagger_client.rest import ApiException
from swagger_client.models.typing import Typing


class TestTyping(unittest.TestCase):
    """ Typing unit test stubs """

    def setUp(self):
        pass

    def tearDown(self):
        pass

    def testTyping(self):
        """
        Test Typing
        """
        model = swagger_client.models.typing.Typing()


if __name__ == '__main__':
    unittest.main()
