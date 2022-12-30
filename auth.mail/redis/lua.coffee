> ./key > R_MAIL_HOST R_MAIL R_UID_MAIL

< (R,redis)=>
  redis.hasHost = R.fboolR.hasHost
  host_mail = [R_MAIL_HOST, R_MAIL]
  redis.idMail = R.fstrR.idMail(...host_mail)
  redis.mailId = R.fnum.mailId(...host_mail)
  redis.mailIdNew = R.fnum.mailIdNew(...host_mail)
  redis.uidMail = R.fstrR.uidMail(R_UID_MAIL, ...host_mail)
  return
