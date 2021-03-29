.. obogaf::parser documentation master file, created by
   sphinx-quickstart on Sat Oct 19 14:58:08 2019.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to obogaf::parser's documentation!
==========================================

``obogaf::parser`` is a perl5 module designed to handle **GO** and **HPO** obo file and their gene annotation file (gaf file). However, all the ``obogaf::parser`` subroutines can be safely used to parse any *obo* file listed in `OBO foundry <http://www.obofoundry.org/>`_ and any gene *annotation* file structured as those shown in `GOA website <https://www.ebi.ac.uk/GOA/downloads>`_ and `HPO website <https://hpo.jax.org/app/download/annotation>`_ -- basically a ``csv`` file using ``tab`` as separator). 

Subroutines contained in ``obogaf::parser``:

- **build_edges**: extract edges from an ``obo`` file;
- **build_subonto**: extract edges for a specific subontology domain;
- **make_stat**: make basic statistic on a graph;
- **get_parents_or_children_list**: build parents or children list for each node of the graph;
- **obo_filter**: prune obo file relatively to a set of given ontology terms;
- **gene2biofun**: build the annotations list from a gaf file;
- **map_OBOterm_between_release**: map ontology terms between releases;

To call an ``obogaf::parser`` subroutine you must preface the subroutine's name with the name of the library (``obogaf::parser``) and double colon (``::``): ``obogaf::parser::subroutine-to-call``. See examples in :ref:`tutorial` section for more details.

.. toctree::
   :caption: Installation & Getting Started
   :name: getting-started
   :maxdepth: 1
   :hidden:

   quickstart
   install

.. toctree::
    :caption: Usage & Tutorial
    :name: obogaf-parser-usage
    :maxdepth: 1
    :hidden:

    usage
    tutorial
    script 
    
.. toctree::
    :caption: Tips & Tricks
    :name: tips-tricks
    :maxdepth: 1
    :hidden:

    faq


.. toctree::
    :caption: Project Info
    :name: project-info
    :maxdepth: 1
    :hidden:

    contributing
    authors
    history
    license
