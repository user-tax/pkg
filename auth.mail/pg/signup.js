// NOT EDIT : use sh/gen/sql_func.coffee gen

import {UNSAFE} from '~//Pg/index'

export default async (client_id,mail_id,ctime,password_hash)=>{
  return (await UNSAFE(
    'SELECT auth_mail.signup($1,$2,$3,$4)',
    client_id,mail_id,ctime,password_hash
  ))[0][0]
}