#!/usr/bin/env coffee

> ~/Pg/index > LI0
  fs > existsSync mkdirSync
  ~/Pg/PG_URI
  ~/ROOT
  path > join dirname
  utax/read
  utax/write
  ~/MOD
  zx/globals:

SRC = join dirname(ROOT),'src'
SCHEMA_MOD = {}

for i from MOD
  if i == 'core'
    s = 'public'
  else
    s = i.replaceAll(/[\.-]/g,'_')
  SCHEMA_MOD[s] = i

RUN = []
CREATE_KIND = [
  'INDEX'
  'TABLE'
  'SEQUENCE'
]

dump = (pkg, schema, out)=>
  RUN.push do =>
    await $"pg_dump #{PG_URI} --no-owner --no-acl -s -n #{schema} -f #{out}"

    sql = read(out).split('\n').filter(
      (i)=>
        i and not i.startsWith('--')
    ).map(
      (sql)=>
        create = 'CREATE SCHEMA '
        if sql.startsWith create
          s = sql[14..-2]
          search_path = s
          if s != 'public'
            search_path+=',public'
          sql = "#{create}IF NOT EXISTS #{s};\nSET search_path TO #{search_path};"
        else
          sql = sql.replaceAll('public.','').replaceAll('CREATE FUNCTION ','CREATE OR REPLACE FUNCTION ')
          for i from CREATE_KIND
            sql = sql.replaceAll(
              "CREATE #{i} "
              "CREATE #{i} IF NOT EXISTS "
            )
        sql
    ).join('\n')
    write(out,sql)
    return pkg
  return

< default main = ->
  for schema from await LI0"SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN ('information_schema', 'pg_toast', 'pg_catalog')"
    pkg = SCHEMA_MOD[schema]
    if not pkg
      continue

    out = join SRC,pkg,'init/pg'
    if not existsSync out
      mkdirSync(out, { recursive: true })

    out += '/table.sql'
    dump(pkg,schema,out)
  return await Promise.all RUN

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  console.log await main()
  process.exit()
