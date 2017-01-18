Gene Feature Enumeration Service
================================

The Gene Feature Enumeration (GFE) Submission service provides an API for converting raw sequence data to GFE. 
It provides both a RESTful API and a simple user interface for converting raw sequence data to GFE results. 
Sequences can be submitted one at a time or as a fasta file. 
This service uses `feature service`_ for encoding the raw sequence data and `annotation pipeline`_ for aligning the raw sequence data. 
A public version of this service is available for use at gfe.b12x.org. 


The code is open source, and `available on GitHub`_.

.. _feature service: http://readthedocs.org/
.. _annotation pipeline: http://sphinx.pocoo.org/
.. _available on GitHub: http://github.com/rtfd/readthedocs.org

The main documentation for the site is organized into a couple sections:

* :ref:`about-docs`
* :ref:`user-docs`
* :ref:`feature-docs`


.. _about-docs:

.. toctree::
   :maxdepth: 2
   :caption: About GFE

   overview
   feature-service
   hsa

.. _user-docs:

.. toctree::
   :maxdepth: 2
   :caption: User Documentation

   gettingstarted
   restcalls
   swagger
   tools
   clients

.. _feature-docs:

.. toctree::
   :maxdepth: 2
   :glob:
   :caption: Developer Documentation

   installation
   contributing
   docker


