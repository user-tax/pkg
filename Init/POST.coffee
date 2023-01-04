#!/usr/bin/env coffee

> ./conf > ROOT
  ~/CONF > PKG
  json5
  fs > existsSync
  path > join
  utax/write

< default main = =>
  POST = [
    '''
    import merge from 'lodash-es/merge'
    const MOD = {}
    export default MOD\n
    '''
  ]
  for pkg from PKG
    dir = join ROOT,pkg

    if not existsSync join dir,'post.js'
      continue

    out = t = {}
    li = pkg.split('.')
    end = li.pop()
    for i from li
      t = t[i] = {}
    t[end] = 0
    t = json5.stringify(out).replace(':0}',":await import('./#{pkg}/post.js')}")
    POST.push "merge(MOD,#{t})"

  write(
    join ROOT, 'POST.js'
    POST.join('\n')
  )
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()

