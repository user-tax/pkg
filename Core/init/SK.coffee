#!/usr/bin/env coffee

> ~/Redis > R R_CONF
  @u6x/ru > randomBytes

< default main = =>
  if not await R.hexist R_CONF, 'SK'
    SK = randomBytes(32)
    await R.hset R_CONF,{SK}
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
