function hasHost(keys, args)
	-- flags no-writes
	local set = keys[1]
	local host = args[1]
	local pre = host
	local p = 0
	repeat
		p = string.find(host, ".", p + 1, true)
		if p then
			p = p + 1
			if SISMEMBER(set, pre) == 1 then
				return true
			end
			pre = string.sub(host, p)
		else
			return false
		end
	until false
end

function mailIdNew(keys, args)
	local host_key, mail_key = unpack(keys)
	local s = args[1]
	local p = s:find("@")
	local host_id = _zid(host_key, s:sub(p + 1))
	local mail = s:sub(1, p) .. intBin(host_id)
	return _zid(mail_key, mail)
end

function mailId(keys, args)
	local host_key, mail_key = unpack(keys)
	local s = args[1]
	local p = s:find("@")
	local host_id = ZSCORE(host_key, s:sub(p + 1))
	if host_id ~= nil then
		local mail = s:sub(1, p) .. intBin(host_id)
		local id = ZSCORE(mail_key, mail)
		if id then
			return id
		end
	end
	return 0
end

local _idMail = function(k_host, k_mail, id)
	local mail = _byZid(k_mail, id)
	if mail ~= nil then
		local p = mail:find("@")
		if p ~= nil then
			local host = _byZid(k_host, binInt(mail:sub(p + 1)))
			if host ~= nil then
				return mail:sub(1, p) .. host
			end
		end
	end
end

function idMail(keys, args)
	-- flags no-writes
	local k_host, k_mail = unpack(keys)
	return _idMail(k_host, k_mail, args[1])
end

function uidMail(keys, args)
	-- flags no-writes
	local k_uid_mail, k_host, k_mail = unpack(keys)
	local mail_id = HGET(k_uid_mail, args[1])
	if mail_id ~= nil then
		return _idMail(k_host, k_mail, mail_id)
	end
end
