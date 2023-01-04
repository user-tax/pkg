#!/usr/bin/env coffee

> ~/MOD
  path > join
  fs > existsSync
  utax/read
  chalk
  ~/ROOT
  assert/strict:assert

{blueBright} = chalk

< default main = (pkg=MOD)=>
  for mod from pkg
    if not existsSync join ROOT,mod,'init.js'
      continue
    fp = '~/'+mod+'/init'
    try
      {default:li} = await import(fp)
      assert Array.isArray li
    catch err
      console.error "❌",fp
      throw err
    for fp from li
      fp = "/#{mod}/init/#{fp}"
      console.log blueBright mod+fp
      {default:m} = await import('~'+fp)
      await m()

  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()
