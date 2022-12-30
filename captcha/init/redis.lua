function ipLimit(keys,args)
  local ipLimit30s = keys[1]
  if INCR(ipLimit30s) > 3 then
    return TTL(ipLimit30s) + 1
  else
    EXPIRE(ipLimit30s,30)
  end
end
