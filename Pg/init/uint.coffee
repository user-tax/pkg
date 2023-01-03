#!/usr/bin/env coffee

> ./conf > PWD
  path > join
  utax/write
  ../PgConn

< default main = =>

  PG = PgConn({})
  li = [[20,'bigint']]
  for [oid,name] from await PG"select oid,typname from pg_type where typname in ('u64','u32','u16','u8')".values()
    li.push [oid,name]
  li.sort()
  fp = join(PWD, '..', 'PG_UINT.js')
  console.log fp
  write(
    fp
    'export default '+JSON.stringify(li)
  )
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()

