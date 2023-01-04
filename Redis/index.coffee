#!/usr/bin/env coffee

> ./lua
  ./cls
  ./conn

import * as KEY from './pkg/key'

$ = cls conn,lua

< R = conn

< default R

do =>
  for [k,v] from Object.entries KEY
    {bind} = v
    if bind
      delete v.bind
      $ v,bind
  return

export * from './pkg/key'
