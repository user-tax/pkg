#!/usr/bin/env coffee

> ~/ROOT
  path > join dirname
  fs > existsSync
  ./rsync
  ./i18n

LIB = join dirname(ROOT), 'lib'

< main = =>
  await i18n()
  await rsync()
  {default:MOD} = await import("~/MOD")
  for pkg from MOD
    fp = join LIB,pkg,'init/build.js'
    if existsSync fp
      {default:build} = await import(fp)
      console.log fp
      await build()
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()

