#!/usr/bin/env coffee

DIR = './'

if process.argv[2] == 'fork'
  await import(DIR+'fork.js')
else
  (await import(DIR+'boot.js')).default(
    decodeURI (
      new URL(import.meta.url)
    ).pathname
  )
