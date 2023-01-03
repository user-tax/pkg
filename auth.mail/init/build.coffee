#!/usr/bin/env coffee

> utax/req > reqText
  utax/write
  path > join
  ~//auth.mail/init/conf > PWD

PROXY="https://ghproxy.com/https:"

< default main = =>
  url = PROXY+"//raw.githubusercontent.com/7c/fakefilter/main/json/data.json"
  write(
    join PWD,'mail_ban_host.json'
    await reqText(url)
  )
  return

if process.argv[1] == decodeURI(new URL(import.meta.url).pathname)
  await main()
  process.exit()
