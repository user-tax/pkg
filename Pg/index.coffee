#!/usr/bin/env coffee

> ./PgConn
  ./PG_UINT.js
  chalk
  ~/Http/CONF > DEBUG

{red,bgRedBright,greenBright,gray} = chalk

types = {}
for [val,name] from PG_UINT
  types[name] = {
    to:val
    from:[val]
    serialize:(x)=>x.toString()
    parse:(x)=>parseInt(x)
  }

< PG = PgConn types

sql_escape = (i)=>
  if i instanceof Uint8Array
    i = '\'\\x'+Buffer.from(i).toString('hex')+'\'::bytea'
  else
    switch typeof i
      when 'string'
        return '\''+i.replaceAll('\'','\\\'')+'\''
    return i+''

_sql = (args)=>
  li = []
  for i from args[1..]
    {first} = i
    if first
      li = li.concat first.map sql_escape
    else
      li.push sql_escape i

  r = await PG(args[0],...args[1..]).describe?()
  if r
    {string} = r
  else
    string = args[0]

  string.replace(
    /(\$\d+)/g
    (x)=>
      return li[x[1..]-1]
  )

if DEBUG
  _try = (func)=>
    (args...)=>
      begin = new Date
      try
        r = await func.apply(func, args)
      catch err
        console.trace()
        console.error bgRedBright err.message
        console.error red await _sql args
        return []
      console.log gray(
        Math.round(new Date - begin)/1000+'s'
      ),greenBright await _sql args
      r
else
  _try = (func)=>
    (args...)=>
      try
        return await func.apply(func, args)
      catch err
        console.trace()
        console.error bgRedBright err.message
        console.error red await _sql args
      return []

Q = _try (sql,args)=>
  PG(sql,...args).values()

< UNSAFE = _try (query, args...)=>
  PG.unsafe(query, args).values()

< RAW = _try (sql, args...)=>
  PG(sql,...args).raw()

< LI = (sql,args...)=>
  Q(sql,args)

< LI0 = (sql,args...)=>
  (await Q(sql,args)).map((i)=>i[0])

< ONE = (sql,args...)=>
  for i from await Q(sql,args)
    return i
  return

< ONE0 = (sql,args...)=>
  for i from await Q(sql,args)
    return i?[0]
  return

< EXE = _try (sql, args...)=>
  PG(sql,...args).execute()


