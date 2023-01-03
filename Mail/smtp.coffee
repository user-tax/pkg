#!/usr/bin/env coffee

> nodemailer
  utax/strbool
  utax/assign
  utax/retry
  ./CONF > SMTP SMTP_FROM

< retry (host, to, subject, text, html)=>
  FROM = {
    name:host
    address: SMTP_FROM
  }

  mail = {
      from: FROM
      to
      #: 'iuser.link@gmail.com'
      subject
      #: '您好 '+new Date
      text
      #: 'text 天气不错 Hello world?'
      html
      #: '<b>天气不错 html Hello world?</b><h1>'+new Date+'</h1>'
  }

  try
    transporter = nodemailer.createTransport(SMTP)
    await transporter.sendMail(mail)
  finally
    transporter?.close()
  return
