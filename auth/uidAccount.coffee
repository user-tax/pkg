#!/usr/bin/env coffee

> ~/Redis > R R_AUTH_LAST R_AUTH_WAY
  @u6x/ru > u64Bin binU64

< WAY_ACCOUNT = new Map()

< uidWay = (uid)=>
  _get = (way)=>
    func = WAY_ACCOUNT.get i
    [
      way
      (
        await func [uid]
      )[0]
    ]

  way = (await R_AUTH_WAY.smembers(uid)).map binU64
  r = []
  for i from way
    r.push _get(i)
  Promise.all r

< default main = (uid_bin_li)=>
  way_li = (
    await R.hmget R_AUTH_LAST,...uid_bin_li
  ).map binU64

  way_uid = new Map()
  for i,pos in way_li
    if not i
      continue
    uid = uid_bin_li[pos]
    li = way_uid.get(i)
    if li
      li.push uid
    else
      way_uid.set(i, [uid])

  way_uid = Array.from way_uid.entries()

  account_li = []

  for [way,li] from way_uid
    func = WAY_ACCOUNT.get way
    account_li.push func li

  account_li = await Promise.all account_li

  uid_account = new Map()

  for [way,li],p1 in way_uid
    for account,p2 in account_li[p1]
      uid = li[p2]
      uid_account.set uid, [way, account]

  uid_account


if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  do =>
    await import('../auth.mail/hook')
    console.log await main([1])
    return
