#!/usr/bin/env coffee

> @u6x/ru > Redis serverHostPort serverCluster
  prexit
  ./CONF > REDIS_DB REDIS_PASSWORD REDIS_USER REDIS_HOST_PORT

redis = await Redis(
  if Array.isArray REDIS_HOST_PORT[0] then serverCluster(REDIS_HOST_PORT) else serverHostPort(...REDIS_HOST_PORT)
  REDIS_DB
  REDIS_USER
  REDIS_PASSWORD
)

prexit =>
  await redis.quit()
  return

< default redis
