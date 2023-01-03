#!/usr/bin/env coffee

> @rmw/thisdir
  path > dirname

< PWD = thisdir import.meta
< ROOT = dirname dirname dirname PWD

