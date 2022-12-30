> utax/msgpack > pack unpack
  ~/R > R R_CONF
  @u6x/ru > xxh3B36
  utax/time > Hour

export SK = await R.hgetB R_CONF,'SK'

_code = (hour, args)=>
  msg = pack args.concat [hour]
  xxh3B36(
    msg
    SK
  )

< skCode = (args...)=>
  _code(
    Hour(), args
  )

< skVerify = (code, args...)=>
  code = code.trim()
  hour = Hour()
  (
    code == _code(hour, args) or code == _code(hour-1, args)
  )

