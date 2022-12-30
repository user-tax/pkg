#!/usr/bin/env coffee

< default INIT = [
  'mail_ban_host'
]

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  for i in INIT
    console.log i
    {default:init} = await import('./init/'+i)
    await init()
