> ~/pkg/u/canEdit
  ~/ERR > USED ERR_CODE
  ~/http/Err > ERR
  ~/R > R R_UID_MAIL
  ~/pkg/Core/sk > skVerify
  ../pg/uidByMailId
  ../pg/mailSet
  ../lib > mailValid sendMail
   @u6x/ru > binU64

_old_mail = (uid, account)=>
  r = await mailValid account
  if Number.isInteger r
    return r
  [account, ban] = r

  if ban
    return ban

  mail_id = await R.mailId account
  if mail_id
    if await uidByMailId(mail_id)
      return USED
  [
    await R.uidMail uid
    account
  ]

ACTION = 'modifyMail'

< canEdit (uid,account,code,old_code)->
  r = await _old_mail(uid, account)
  if Number.isInteger r
    return r
  [old_mail, account] = r

  err = {}
  if old_mail
    if not skVerify(
      old_code
      ACTION
      @origin
      old_mail
      account
    )
      err.old = ERR_CODE

  if not skVerify(
    code
    ACTION
    @origin
    account
    (old_mail or '')
  )
    err.now = ERR_CODE

  ERR err
  mail_id = await R.mailIdNew account
  await Promise.all [
    mailSet mail_id, binU64(uid)
    R.hset(
      R_UID_MAIL
      uid
      mail_id
    )
  ]
  return

< mail = canEdit (uid,account)->
  r = await _old_mail(uid, account)
  if Number.isInteger r
    return r
  [old_mail, account] = r

  if old_mail
    sendMail.call @, ACTION, old_mail, account

  sendMail.call @, ACTION, account, (old_mail or '')
  return
