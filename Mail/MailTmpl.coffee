> ~/Redis:R
  utax/split

< new Proxy(
  {}
  get:(_,pkg)=>
    key = 'i18n:'+pkg
    (lang)=>
      for l from [lang,'en']
        txt = await R.hget(key,lang)
        if txt
          break
      split(txt,'\n').concat [l]
)
