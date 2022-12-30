local log = function(...)
	redis.log(redis.LOG_NOTICE, ...)
end

local _byZid = function(key, score)
	score = tonumber(score)
	local r = redis.call("ZRANGEBYSCORE", key, score, score, "LIMIT", 0, 1)
	if r then
		return r[1]
	end
end

local intBin = function(n)
	local t = {}
	while n > 0 do
		local r = math.fmod(n, 256)
		table.insert(t, string.char(r))
		n = (n - r) / 256
	end
	return table.concat(t)
end

local binInt = function(str)
	local n = 0
	local base = 1
	for i = 1, #str do
		local c = str:sub(i, i)
		n = n + base * c:byte()
		base = base * 256
	end
	return n
end

local HSET = function(key, field, val)
	return redis.call("HSET", key, field, val)
end

local HGET = function(key, field)
	return redis.call("HGET", key, field)
end

local HINCRBY = function(key, field, increment)
	return redis.call("HINCRBY", key, field, increment)
end

local INCR = function(key)
	return redis.call("INCR", key)
end

local ZSCORE = function(key, member)
	local r = redis.call("ZSCORE", key, member)
	if r then
		return r.double
	end
end

local ZADD_XX = function(key, member, score)
	return redis.call("ZADD", key, "XX", score, member)
end

local ZADD = function(key, member, score)
	return redis.call("ZADD", key, score, member)
end

local ZINCRBY = function(key, member, increment)
	return redis.call("ZINCRBY", key, increment, member).double
end

local SISMEMBER = function(key, member)
	return redis.call("SISMEMBER", key, member)
end

local EXPIRE = function(key, seconds)
	return redis.call("EXPIRE", key, seconds)
end

local TTL = function(key)
	return redis.call("TTL", key)
end

local _zid = function(kv, k)
	local id = ZSCORE(kv, k)
	if nil == id then
		id = -ZINCRBY(kv, "", -1)
		ZADD(kv, k, id)
	end
	return id
end

function zid(keys, args)
	return _zid(keys[1], args[1])
end

function zmax(keys, args)
	-- flags no-writes
	local zset = keys[1]
	local max = redis.call("ZRANGE", zset, 0, 0, "REV", "WITHSCORES")
	if next(max) ~= nil then
		local min = args[1]
		if min ~= nil then
			min = tonumber(min)
			local max = max[1]
			if max[2].double > min then
				return max[1]
			end
		end
	end
end

function zero(keys, args)
	local key = keys[1]
	local t = redis.call("ZRANGEBYSCORE", key, "(0", "+inf")
	local r = {}
	for i = 1, #t do
		table.insert(r, 0)
		table.insert(r, t[i])
	end
	redis.call("ZADD", key, unpack(r))
end

local _ztouch = function(func, keys, args)
	local zset = keys[1]
	local key = args[1]
	local max = redis.call("ZRANGE", zset, 0, 0, "REV", "WITHSCORES")
	if next(max) == nil then
		max = 1
	else
		max = max[1]
		local val = max[2].double
		if max[1] == key and val ~= 0 then
			return
		end
		max = val + 1
	end
	func(zset, key, max)
end

function ztouch(keys, args)
	_ztouch(ZADD, keys, args)
end

function ztouchXx(keys, args)
	_ztouch(ZADD_XX, keys, args)
end

function ver()
	-- flags no-writes
	return "VERSION"
end
