> @u6x/ru > zipU64 binU64 u64Bin
  ~/Redis > R R_CLIENT_USER R_USER_NAME R_AUTH_WAY
  ~/auth/uidAccount:@ > uidWay
  ./canEdit
  utax/wcut

< ->
  {I} = @
  key = u64Bin I
  li = await R_CLIENT_USER.zrevrangebyscoreWithscores(
    key
  )

  if not li.length
    return [[],[]]

  + pos

  li = li.map(
    ([id,s], n)=>
      if pos == undefined
        if s == 0
          pos = n
      id
  )

  if pos == undefined
    pos = li.length

  uid_account = await uidAccount li

  r = (
    await R.hmgetS R_USER_NAME, ...li
  ).map (name,p)=>
    id = li[p]
    [
      binU64(id)
      name
      ...uid_account.get(id)
    ]
  [
    r[...pos]
    r[pos..]
  ]

< me = ->
  key = u64Bin @I
  uid = await R_CLIENT_USER.zmax(key) 0
  if uid
    name = await R.hget R_USER_NAME,uid
    uid = binU64 uid
    return [uid,name]
  return

< exit = (id)->
  key = u64Bin @I
  await R_CLIENT_USER.zaddXx key,u64Bin(id),0
  return

< exitAll = ->
  key = u64Bin @I
  await R_CLIENT_USER.zero(key)()
  return

< rmAll = ->
  key = u64Bin @I
  await R_CLIENT_USER.del key
  return

< rm = (id)->
  key = u64Bin @I
  id = u64Bin +id
  await R_CLIENT_USER.zrem key, id
  return

< enter = (id)->
  key = u64Bin @I
  id = u64Bin +id
  await R_CLIENT_USER.ztouchXx(key) id
  return

< name = canEdit (id, name)->
  name = name.trim()
  if name
    R.hset R_USER_NAME, id, wcut(name,24)
  return

< conf = canEdit (id)->
  Promise.all [
    R.hget R_USER_NAME, id
    uidWay(id)
  ]


