.. |br| raw:: html

   <br />

Kinto
#####

Kinto is a minimalist JSON storage service (store, sync, share)

* Python Meetup Barcelona
* July 2016
* https://kinto.readthedocs.io

----

Highlights
==========

* Why ?
* How ?
* About Pyramid

----

Why ?
=====

* universal
* reusable
* Featured twice on Hackernews as «*Open Source alternative to Parse and Firebase*»

* data ownership

----

3 steps to building a new Web app

----

At Mozilla

----

How ?
=====

----

Core
====

* Hierarchy of REST resources (buckets > collections > records)
* Fined-grained permission tree
* Filtering + Sorting + Paginating
* Monitoring
* HTTP API best practices

----

* Plain INI files + ENV vars
* Pluggable authentication methods

----

Plugins
=======

Examples of available addons:

* File attachments
* History of changes
* Push notifications
* Digital signatures (crypto)
* LDAP authentication
* ...

----

Records storage
===============

PostgreSQL backend (*recommended*):

* Raw SQL queries (single table with JSONB)
* SQLAlchemy (engine, pools, transactions, ...)
* Per-request transactions
* Minimalist schema migrations

----

Permissions
===========

* Pluggable (multi)-authentication « policies »
* Permission backend (ACLs)
* Intersection of «principals» (~roles)

----

Cache
=====

* Redis (*recommended*)
* Key/value with «Time-To-Live»
* Used by authentication, plugins, ...

----

Clients
=======

* Python (abstraction on top of requests)
* JavaScript (ES6)
* Web Admin UI (React/Redux)
* Offline-first (IndexedDB)

----

< Screenshot >

----

About Pyramid
=============

----

Key properties
==============

* «Pay for what you eat»
* Very stable API
* Good patterns

* Flexibility
* Extensibility

----

Minimalist ``app.wsgi`` file:

.. code-block:: python

    from myapp import main

    config = configparser.ConfigParser()
    config.read('config.ini')

    application = main(**dict(config.items('app:main')))

----

.. code-block:: python

    from pyramid.config import Configurator

    def main(**settings):
        config = Configurator(settings=settings)

        # Initialization steps using `config`.

        return config.make_wsgi_app()

----

Explict initialization
======================

Imperative

* Less magic
* Reproductible / testable

.. code-block:: python

    config.add_route('hello', '/')
    config.add_view(view_hello, route_name='hello')

Declarative with decorators:

.. code-block:: python

    @view_config(route_name='hello')
    def view_hello(request):
        return {"hello": "pybcn"}

(+ explicit ``config.scan()``)

----

Configuration methods
=====================

«Backbone» of the project

* ``config.add_route()`` / ``config.add_view()``
* ``config.set_authentication_policy()`` / set_authorization_policy()``
* ``config.add_subscriber()``
* ``config.add_directive()``
* ``config.add_renderer()``
* ``config.add_response_adapter()``
* ...

----

Extensibility
=============

Include any package:

.. code-block:: python

    config.include('cornice')

Or via the settings:

.. code-block:: ini

    pyramid.includes = webmaps_addon

----

An addon is just a single Python module with ``def includeme(config)``:

.. code-block:: python

    def includeme(config):
        # Add custom view renderer.
        config.add_renderer(name='geojson', factory='webmaps.GeoJSONRenderer')

----

Hook everything
===============

* Powerful route/views mapping
* Events, callbacks, tweens, adapters, renderers, ...
* Plain INI settings files
* Custom configuration «directives»

----

.. code-block:: python

    def add_api_capability(config, identifier, description="", **kwargs):
        capability = dict(description=description, **kwargs)
        config.registry.api_capabilities[identifier] = capability

    config.add_directive('add_api_capability', add_api_capability)

New directive becomes available:

.. code-block:: python

    config.add_api_capability('history', description="History plugin")

----

.. code-block:: python

    @hello.get()
    def get_hello(request):
        data = {
            'capabilities': request.registry.api_capabilities
        }
        return data

----

Python modules from settings
============================

Easily load modules from settings files:

.. code-block:: python

    settings = config.get_settings()
    cache_mod_name = settings['cache_backend']

    cache_module = config.maybe_dotted(cache_mod_name)
    backend = cache_module(settings)

----

Services
========

Declare interfaces and register components:

.. code-block:: python

    from pyramid.interfaces import IRoutesMapper

    mapper = DummyRoutesMapper()
    request.registry.registerUtility(mapper, IRoutesMapper)

----

Other parts of the code can query the registry:

.. code-block:: python

    from pyramid.interfaces import IRoutesMapper

    route_mapper = registry.queryUtility(IRoutesMapper)
    info = route_mapper(request)

----

Events / Subscribers
====================

.. code-block:: python

    class ServerFlushed(object):
        def __init__(self, request):
            self.request = request

    def view_flush_post(request):
        request.registry.storage.flush()

        event = ServerFlushed(request)
        request.registry.notify(event)

-----

.. code-block:: python

    def on_server_flush(event):
        request = event.request
        request.response.headers['Alert'] = 'Flush'

    config.add_subscriber(on_server_flush, ServerFlushed)

-----

Compose instead of inherit
==========================

* Readability
* Flexibility
* Leverage composition between uncoupled packages
* Avoid multiple inheritance (eg. mixins)
* Single responsability principle

.. code-block:: python

    class Backend:
        def permits(self):
            return self.context.is_allowed()

    backend.context = MyContext()

-----

Downsides
=========

* Pyramid is not the «latest cool stuff»
* Documentation lacks «real-life examples» (e.g. ACL)
* Easy to couple everything to ``request``
* Built-in authentication policies are not intuitive
* Request objects are not easily clonable

-----

Conclusion
==========

-----

