#!/usr/bin/env luajit

local pprint = require('pprint')

-- local keys = {'z','x','b'}
-- local id,host,mail = binInt(keys)
-- print(id,host,mail)
--
--
function string.hex(str)
  return (str:gsub('.', function (c)
    return string.format('%02X', string.byte(c))
  end))
end

function intBin(n)
  local t = {}
  while n > 0 do
    local r = math.fmod(n, 256)
    table.insert(t, string.char(r))
    n = (n-r) / 256
  end
  return table.concat(t)
end

function binInt(str)
  local n = 0
  local base = 1
  for i = 1, #str do
    local c = str:sub(i,i)
    n = n + base * c:byte()
    base = base * 256
  end
  return n
end

function mailDump(s,host_id)
  local p = s:find('@')
  return s:sub(1,p)..intBin(host_id)
end

function mailLoad(s)
  local p = s:find('@')
  return {s:sub(1,p), binInt(s:sub(p+1))}
end

print(intBin(256):hex())
print(intBin(255):hex())
-- print(intBin(9123456):hex())
-- print(intBin(19123456):hex())

print(binInt(intBin(256)))
print(binInt(intBin(255)))
print(binInt(intBin(10255)))
print(binInt(intBin(110255)))
print(binInt(intBin(3110255)))

pprint(mailLoad(mailDump('123@456.79x',133)))
