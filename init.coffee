#!/usr/bin/env coffee

> zx/globals:
  @u7/uridir
  @u7/yml/Yml
  fs > existsSync rmSync symlinkSync
  path > join dirname

PWD = uridir import.meta
ROOT = dirname PWD
SYMLINK = [
  'styl'
  'ui'
]

symlink = (dir)=>
  for i from SYMLINK
    to = join(ROOT, i, 'src', dir)
    rmSync to, recursive:true, force:true
    if existsSync join PWD, dir, i
      console.log to
      symlinkSync(
        join '../../pkg',dir,i
        to
      )
  return

cdRun = new Proxy(
  {}
  get:(_,dir)=>
    (cmd)=>
      cd dir
      await $ cmd
      cd '..'
      return
)

< default main = =>
  {pkg:{git}} = Yml(PWD)
  for i from git
    cd PWD
    name = i.split('/').pop()
    if name.endsWith('.git')
      name = name[..-5]
    if not existsSync name
      await $"git clone --recursive --depth=1 #{i}"

      cd name
      if existsSync '.envrc'
        await $'direnv allow'

      if existsSync join(PWD,name,'api/.envrc')
        await cdRun.api"direnv allow"

      if existsSync join(PWD,name,'ui/package.json')
        await cdRun.ui"pnpm i"
    symlink name
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  await import('./i18n')
  process.exit()

