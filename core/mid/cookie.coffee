> @u6x/ru > b64 unb64 randomBytes cookieDecode cookieEncode xxh64 ipBin zipU64 unzipU64
  utax/u8 > U8 u8eq u8merge
  ~/pkg/core/sk > SK
  ~/pkg/core/pg/clientNew
  ~/pkg/redis/ID

{CLIENT_ID} = ID


+ DAY, PRE_DAY

_day = =>
  expire = 200
  DAY = parseInt(new Date()/864e6)%expire
  pre = DAY + expire - 1
  # https://chromestatus.com/feature/4887741241229312
  # When cookies are set with an explicit Expires/Max-Age attribute the value will now be capped to no more than 400 days
  PRE_DAY = [pre%expire,(pre-1)%expire]
  return

_day()
setInterval _day, 864e5

SK_LEN = 8

_set = (client_id)->
  args = zipU64 DAY,client_id
  sk = xxh64(SK,args)
  cookie = cookieEncode(sk, args)
  @['Set-Cookie'] = "I=#{cookie};max-age=99999999;domain=#{@host};path=/;HttpOnly;SameSite=None;Secure"
  return

_new = ->
  client_id = await CLIENT_ID()

  clientNew(
    client_id
    ipBin @ip
    ...@agent
  )
  _set.call @,client_id
  client_id

< ->

  {I,agent} = @

  if I
    try
      I = cookieDecode I
    catch
      I = undefined

    if I and I.length > SK_LEN
      sk = I[...SK_LEN]
      I = I[SK_LEN..]
      if not u8eq xxh64(SK,I),sk
        I = undefined

  if I
    [day, client_id] = unzipU64 2,I
    if day != DAY
      if PRE_DAY.includes day
        _set.call @,client_id
      else
        client_id = await _new.call @
  else
    client_id = await _new.call @

  {
    I:client_id
  }
