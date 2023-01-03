// NOT EDIT : use sh/gen/sql_func.coffee gen

import {UNSAFE} from '~//Pg/index'

export default async (mail_id)=>{
  return (await UNSAFE(
    'SELECT * FROM auth_mail.uid_by_mail_id($1)',
    mail_id
  ))[0]
}