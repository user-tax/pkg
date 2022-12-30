#!/usr/bin/env coffee

> postgres
  ./PG_URI
  ./CONF > PG_POOL_CONN
  prexit

< (types)=>
  pg = postgres(
    PG_URI
    {
      # idle_timeout: 60
      prepare: true
      max: PG_POOL_CONN
      types
    }
  )

  prexit =>
    await pg.end({ timeout: 5 })
    return

  pg
