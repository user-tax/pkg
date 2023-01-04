#!/usr/bin/env coffee

> ../auth/uidAccount > WAY_ACCOUNT
  ~/auth/way > MAIL
  ~/Redis:R

WAY_ACCOUNT.set(
  MAIL
  (id_li)=>
    Promise.all id_li.map (id)=>
      R.uidMail(id)
)
