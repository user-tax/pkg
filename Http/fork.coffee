> ./worker

exit = =>
  process.kill(process.pid, "SIGINT")
  return

MAX_MEM_LEAK = 256
{memoryUsage} = process
{ rss } = memoryUsage()

gcpoint = 32

N = 0
ING = 0

# 定时任务: 没请求就退出，防止孤儿进程
INTERVAL = setInterval(
  =>
    if N == 0
      exit()
    else
      N = 0
      used = memoryUsage().rss
      diff = (used - rss)/1048576
      if gcpoint > MAX_MEM_LEAK and diff > MAX_MEM_LEAK
        clearInterval INTERVAL
        next = =>
          if ING == 0
            exit()
          else
            console.log 'memoryUsage', used, 'leak', diff, 'ING', ING, 'wait auto exit'
          return
        setInterval(
          next
          1e3
        )
        return
      else if diff > gcpoint
        gc()
        gcpoint += 32
    return
  4e4
)

next = (msg)=>
  if Array.isArray msg
    ++N
    ++ING
    rid = msg.pop()
    try
      process.send [
        rid
        await worker msg
      ]
    finally
      --ING
  else
    switch msg
      when 0
        exit()
      else
        console.log msg
  return

process.on 'message',(msg)=>
  next(msg)
  return
