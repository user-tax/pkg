#!/usr/bin/env coffee

> fs > readdirSync
  @u7/yml > load dump
  path > join

NO_SPACE = new Set([ 'ja', 'km', 'lo', 'th', 'zh-TW', 'zh' ])
NO_CASE  = new Set([
  'am',       'ar',    'as',  'bho',
  'bn',       'ckb',   'doi', 'dv',
  'fa',       'gom',   'gu',  'hi',
  'iw',       'ja',    'km',  'kn',
  'ko',       'lo',    'mai', 'ml',
  'mni-Mtei', 'mr',    'my',  'ne',
  'or',       'pa',    'ps',  'sa',
  'sd',       'si',    'ta',  'te',
  'th',       'ti',    'ug',  'ur',
  'yi',       'zh-TW', 'zh'
])

< default main = =>
  dir = "./user/ui.i18n"
  li = []
  for fp from readdirSync dir
    if fp.endsWith '.yml'
      yml_fp = join dir, fp
      lang = fp[..-5]
      if not NO_SPACE.has lang
        o = load yml_fp
        + change
        for [k,v] from Object.entries(o)
          v = v.split()
        if change
          dump(yml_fp, o)
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()

