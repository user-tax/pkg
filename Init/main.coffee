#!/usr/bin/env coffee

> chalk
  ./PkgInit

{greenBright} = chalk

< GEN = [
  'PkgExport'
  'POST'
]

INIT = [
  'i18n'
  'PkgInit'
]

< default main = (li)=>
  for i from li
    console.log greenBright i
    {default:m} = await import('./'+i)
    await m()
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main(
    GEN.concat INIT
  )
  process.exit()
