> utax/u8 > u8merge U8
  utax/utf8 > utf8e
  ~/Http/CONF > DEBUG

_prefix = (prefix, f)=>
  (k, args...)=>
    if (
      (typeof(k) == 'string') or k instanceof String
    )
      k = utf8e k
    k = u8merge prefix, k
    f(
      k
      ...args
    )

key = (prefix)=>
  u8merge(
    prefix
    U8 [0]
  )


< (redis, lua)=>

  proxy_get = (rtype, func)=>
    f = redis[rtype].bind(redis, func)
    (keys...)=>
      (args...)=>
        f(keys,args)

  if DEBUG

    _proxy_get = proxy_get

    proxy_get = (rtype, func)=>
      if func of redis
        throw new Error("R.#{func} exist")
      _proxy_get rtype, func

  lua(
    new Proxy(
      {}
      get:(self, rtype)=>
        new Proxy(
          {}
          get: (_, func)=>
            proxy_get(rtype, func)
        )
    )
    redis
  )

  (prefix, bind)=>
    if bind
      t = key prefix
      for i from bind.split ' '
        prefix[i] = _prefix(
          t
          redis[i]
        )
    prefix

