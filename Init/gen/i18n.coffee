#!/usr/bin/env coffee

> @iuser/i18n
  @rmw/thisdir
  utax/read
  utax/write
  path > join dirname
  json5
  utax/walk > walkRel
  fs > existsSync rmSync readdirSync
  ~/ROOT

MOD = join dirname(ROOT),'src'
I18N = 'i18n'

replace = (pkg)=>
  dir = join MOD, pkg, I18N
  lib = join ROOT, 'lib', pkg, I18N
  hook = join(lib,'hook.js')
  console.log hook
  if existsSync hook
    {default:hook} = await import(hook)
  if not hook
    return

  for await rfp from walkRel dir
    fp = join dir, rfp
    if not ['md','it'].includes fp.split('.').pop()
      continue
    txt = read(fp)
    r = hook?(txt, rfp)
    if r and r!=txt
      write(
        fp
        r
      )
  return true

< default main = =>
  for pkg from readdirSync MOD
    dir_pkg = join MOD,pkg
    dir_i18n = join dir_pkg,I18N
    if existsSync dir_i18n

      src = 'en'
      await i18n(dir_i18n,src)
      if await replace(pkg)
        # 再运行一次，重新生成json
        await i18n(dir_i18n,src)

      dir_json = join dir_i18n, 'json'
      r = {}
      for await fp from walkRel(
        dir_json
        (i)=>
          not i.endsWith '.json'
      )
        r[fp[..-6]] = JSON.parse read join dir_json, fp

      write(
        join dir_pkg,'I18N.js'
        """// Don't edit this ! Edit ./i18n/en.it , then run sh/gen/i18n.coffee

        export default """+json5.stringify r
      )
      rmSync(
        dir_json
        {
          recursive: true
          force: true
        }
      )
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()
