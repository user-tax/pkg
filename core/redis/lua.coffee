< (R, redis)=>
  redis.zid = R.fnum.zid
  redis.ztouch = R.fcall.ztouch
  redis.ztouchXx = R.fcall.ztouchXx
  redis.zmax = R.fbinR.zmax
  redis.zero = R.fcall.zero
  return
