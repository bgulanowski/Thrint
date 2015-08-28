Thrint
======

Dynamic Table-based UI for Core Data on iOS.

This is partly an experiment, but for prototyping and model-centric proof-of-concept apps, should be useful.

Goals
=====

Given any object hierarchy, instantly provide an application for editing model content. Supports custom objects, generic objects, and managed objects.

Customize by providing a configuration file, editable with Splint, Thrint's included configuration editor, built with Thrint.

The configuration allows you to white-list or black-list modules or classes. Classes can be white- or black-listed on a per-module (framework) basis.

Invoke +list on any class, or -propertyList on any object, and gain immediate access to a hierarchy of objects which mirror your model's object graph. Invoke +mutableList or -mutablePropertyList to allow creation, deletion and modification.

Enable the build-time option for NSObject adoption of the THRItem protocol, and you can browse any object hierarchy without writing any code (use the optional configuration to restrict which objects participate). Or adopt various Item protocols, as categories on your model classes, for customized support. Use the built-in model  controllers (THRList and subclasses), or write your own by adopting the various List-oriented protocols. Lists are made of items. Lists facilitate table-based visualization, with items providing the content.

TODO
====

Support for automated wrapping of JSON-based API, using categories on Cocoa collection classes and RESTKit (?)
