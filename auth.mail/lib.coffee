> marked > marked
  utax/split
  ~/pkg/mail/MailTmpl
  ~/pkg/mail/smtp
  ~/ERR > ACCOUNT_INVALID ACCOUNT_TOO_LONG ACCOUNT_MAIL_HOST_BAN
  ~/R > R R_MAIL_BAN_HOST
  ~/pkg/Core/sk > skCode
  ./I18N

< mailValid = (account)=>
  account = account.trim().toLocaleLowerCase()

  if account.length > 254
    return ACCOUNT_TOO_LONG

  if not /^\S+@\S+$/.test(account)
    return ACCOUNT_INVALID

  [mail,host] = split account,'@'
  # https://stackoverflow.com/questions/386294/what-is-the-maximum-length-of-a-valid-email-address
  if mail.length > 64
    return ACCOUNT_TOO_LONG

  if await R.hasHost(R_MAIL_BAN_HOST)(host)
    ban = ACCOUNT_MAIL_HOST_BAN
  return [
    account
    ban
  ]


{ authMailCode } = MailTmpl

< sendMail = (action, account, password)->
  {origin,lang} = @
  [subject, mail, lang] = await authMailCode(lang)

  code = skCode(
    action
    origin
    account
    password
  )

  dict = {
    host:origin
    code
    action:I18N[lang][action]
  }
  subject = subject.render dict
  text = mail.render dict
  dict.code = '<b style="background:#ff0;border:1px dashed #f90;font-weight:bold;padding:8px;font-family:Consolas,Monaco,monospace">'+code+'</b>'
  html = marked.parse(mail).replaceAll(
    '<p>','<p style="font-size:16px">'
  ).render dict
  smtp(
    origin
    account
    subject
    text
    html
  )
  return
