> ~/Redis > R R_ID
  utax/time > Second
  utax/camel

CACHE = new Map
MINUTE = 61

< new Proxy(
  {}
  get:(_, name)=>
    name = camel name.toLowerCase()
    =>
      cache = CACHE.get(name)
      if cache
        id = cache[0]
        max = cache[1]
        if id == max
          [step,time] = cache[2..]
          diff = Second() - time
          step = (
            step * Math.round(MINUTE/(diff+1))
          ) or 1
          max = await R.hincrby(R_ID, name, step)
          id = max - step
          CACHE.set name, [id,max,step,time]
      else
        step = 1
        max = await R.hincrby(R_ID, name, step)
        id = max - step
        cache = [id,max,step,Second()]
        CACHE.set(name, cache)
      return ++cache[0]
)

