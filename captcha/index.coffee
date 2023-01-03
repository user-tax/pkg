> ~/R > R_CAPTCHA
  ~/http/Err > ERR_CAPTCHA
  @u6x/ru > unzipU64 z85Load

< ({type:captcha}) =>
  if captcha
    [id, x, y] = JSON.parse captcha
    try
      id = z85Load id
    catch err
      throw ERR_CAPTCHA
    r = await R_CAPTCHA.getB id
    if r
      [x0,y0,w] = unzipU64 3,r
      if x >= x0 and x<=(x0+w) and y>=y0 and y<=(y0+w)
        R_CAPTCHA.del id
        return
  throw ERR_CAPTCHA
  return
