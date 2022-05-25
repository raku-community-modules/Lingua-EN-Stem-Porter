[![Actions Status](https://github.com/raku-community-modules/Lingua-EN-Stem-Porter/actions/workflows/test.yml/badge.svg)](https://github.com/raku-community-modules/Lingua-EN-Stem-Porter/actions)

NAME
====

Lingua::EN::Stem::Porter - Implementation of the Porter stemming algorithm

SYNOPSIS
========

```raku
use Lingua::EN::Stem::Porter;

say porter("establishment");  # establish
```

DESCRIPTION
===========

Lingua::EN::Stem::Porter implements the Porter stemming algorithm by exporting a single subroutine `porter` which takes an English word and returns the stem given by the Porter algorithm.

AUTHOR
======

John Spurr

COPYRIGHT AND LICENSE
=====================

Copyright 2016 John Spurr

Copyright 2017 - 2022 Raku Community

This library is free software; you can redistribute it and/or modify it under the MIT License 2.0.

