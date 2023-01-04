#!/usr/bin/env coffee

> ~/ROOT
  ~/MOD
  path > join
  fs > existsSync
  utax/camel
  utax/read
  utax/split
  utax/walk > walkRel
  ~/R

< default main = =>
  ing = []
  for pkg from MOD
    dir = join ROOT,pkg,'i18n'
    if existsSync dir
      console.log dir
      for await fp from walkRel(
        dir
      )
        if fp.endsWith '.md'
          [lang, name] = split fp[..-4],'/'
          ing.push R.hset(
            'i18n:'+camel(pkg.replaceAll('.','_')+'_'+name)
            lang
            read(join(dir, fp))
          )
  await Promise.all ing
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()

