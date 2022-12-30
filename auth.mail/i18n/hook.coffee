#!/usr/bin/env coffee

> path

NO_SPACE = new Set ['zh','ja','km','lo','th']

< (txt,fp)=>
  if fp.endsWith '.md'
    txt = txt.split('\n').map((i)=>i.trim()).join('\n')

  li = [
    ['：',':']
    ['e -mail','email']
  ]

  lang = fp.replaceAll('\\','/').split('/',1)[0]

  if fp.endsWith '.md'
    if NO_SPACE.has lang
      li = li.concat [
        [' ${','${']
        ['} ','}']
        ['${host}${','${host} ${']
        [':${',': ${']
      ]
  if lang == 'zh'
    li = li.concat [
      ['验证代码','验证码']
      ['到期','过期']
      ['不申请','未申请']
    ]

  for [f,t] from li
    txt = txt.replaceAll f,t

  txt

