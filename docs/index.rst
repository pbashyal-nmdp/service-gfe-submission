Gene Feature Enumeration Service
================================

The Gene Feature Enumeration (GFE) Submission service provides an API for converting raw sequence data to GFE. 
It provides both a RESTful API and a simple user interface for converting raw sequence data to GFE results. 
Sequences can be submitted one at a time or as a fasta file. 
This service uses `feature service`_ for encoding the raw sequence data and `annotation pipeline`_ for aligning the raw sequence data. 
A public version of this service is available for use at `gfe.b12x.org`_. 

The code is open source, and `available on GitHub`_.

.. _feature service: http://readthedocs.org/
.. _annotation pipeline: http://sphinx.pocoo.org/
.. _available on GitHub: http://github.com/rtfd/readthedocs.org
.. _gfe.b12x.org: http://gfe.b12x.org


.. toctree::
   :maxdepth: 2
   :caption: About GFE

   overview
   hackathons


.. toctree::
   :maxdepth: 2
   :caption: User Documentation

   restcalls
   clients
   tools


.. toctree::
   :maxdepth: 2
   :glob:
   :caption: Developer Documentation

   docker
   installation
   contributing
   

