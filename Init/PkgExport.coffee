#!/usr/bin/env coffee

> path > join dirname basename
  ~/CONF > PKG
  ~/ROOT
  fs > readdirSync existsSync
  utax/camel
  utax/write
  utax/read
  json5

EXPORT = 'const EXPORT = [];\nexport default EXPORT;'

genMid = =>
  li = [EXPORT]
  for pkg from PKG
    fp = join(ROOT,pkg,'mid')
    if existsSync fp
      for i from readdirSync fp
        if i.endsWith '.js'
          li.push "EXPORT.push((await import('./#{pkg}/mid/#{i}')).default)"
  write(
    join ROOT,'MID.js'
    li.join('\n')
  )
  return

genIndex = =>
  for pkg from PKG
    index_js = 'index.js'
    dir = join ROOT, pkg
    if not existsSync join dir,'index.js'
      continue

    index = "/#{pkg}/index"
    fp = join ROOT,pkg+'.js'
    mod = await import('..'+index)

    _from = " from '~#{index}.js'"
    li = [
      "export *"+_from
    ]
    if mod.default
      li.push "export { default }"+_from

    write(
      fp
      li.join('\n')
    )
  return

< default main = =>
  genMid()
  await genIndex()
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()
