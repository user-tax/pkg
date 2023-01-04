#!/usr/bin/env coffee

> ~/Init/ROOT
  ~/MOD
  ../index > PG
  ../PG_URI
  fs > existsSync
  path > join
  utax/read
  chalk

{yellowBright,redBright, greenBright}=chalk

exe = (sql)=>
  sql += ';'
  try
    await PG.unsafe(sql)
  catch err
    console.error yellowBright(sql) + '\n' + redBright(err.message) + '\n'
  return

< default main = =>
  for pkg from MOD
    for name from ['extension','table']
      fp = join ROOT,pkg,"init/pg/#{name}.sql"
      if existsSync fp
        console.log greenBright fp
        sql = read fp
        for i from sql.split(';')
          i = i.trim()
          if not i
            continue
          if i.startsWith 'CREATE OR REPLACE FUNCTION'
            t = [i]
          else if t
            t.push i
            if i.endsWith '$$'
              sql = t.join(';\n')
              await exe sql
              t = undefined
          else
            await exe i
        #await UNSAFE sql
        #await $"psql #{PG_URI} < #{fp} > /dev/null"
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()

