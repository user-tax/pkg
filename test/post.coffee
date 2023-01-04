> ~/Redis > R

< ->
  {host} = @
  val = parseInt(new Date/1000)
  @['Set-Cookie'] = "test=#{val};max-age=9999;domain=#{host};path=/;HttpOnly;SameSite=None;Secure"
  console.log @I
  console.log @
  return ''
