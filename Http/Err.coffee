< class HttpErr
  @(@code,@body)->

err = (code,msg='')=>
  new HttpErr code,msg

< ERR_CAPTCHA = err 412
< ERR_LOGIN = err 401
< ERR = (msg) =>
  if msg
    if Object.entries(msg).length
      throw err 406, JSON.stringify msg
  return

export ERR_HOST_NOT_ALLOW = err 403, 'host not allow'

