#!/usr/bin/env coffee

> utax/read
  ~/R > R R_MAIL_BAN_HOST
  path > join
  ./conf > PWD

< default main = =>
  {t,domains} = JSON.parse read join(PWD,'mail_ban_host.json')
  li = []
  for [host,o] from Object.entries domains
    {lastseen} = o
    if (t - lastseen)/86400 < 365
      li.push host

  console.log '\tmail ban host', li.length
  await R.sadd R_MAIL_BAN_HOST, ...li
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()

