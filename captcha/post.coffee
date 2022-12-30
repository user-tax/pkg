> @user.tax/captcha-img
  utax/u8 > U8
  @user.tax/captcha-img/D.js # svg path
  ~/R > R_CAPTCHA R_CAPTCHA_IP_LIMIT
  @u6x/ru > z85Dump randomBytes svgWebp ipBin zipU64

# 返回验证码 加密的位置和图片id

CACHE = [
  []
  []
]

WIDTH = 350

_new = (radio)=>
  r = CaptchaImg(WIDTH*radio)
  r[0] = await svgWebp r[0], 20
  r

_cache = (radio)=>
  li = CACHE[radio-1]

  add = =>
    _new(radio).then (r)=>li.push(r)
    return

  {length} = li

  if length < 3
    add()

  if length
    return li.pop()

  add()
  _new radio

< default captcha = (radio)->

  ip = ipBin @ip
  r = await R_CAPTCHA_IP_LIMIT.ipLimit(ip)()
  if r
    return r
  radio = if parseInt(radio)>=2 then 2 else 1

  [
    img
    img_id
    x
    y
    captcha_size
  ] = await _cache radio

  if radio == 1
    x*=2
    y*=2
    captcha_size*=2

  loop
    key = randomBytes(8)
    if not await R_CAPTCHA.exist key
      R_CAPTCHA.setex(
        key
        zipU64 x,y,captcha_size
        600
      )
      break
  [
    img
    D[img_id]
    z85Dump key
  ]
