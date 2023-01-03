> utax/msgpack > pack
  ~/POST

obj2map = (obj, chain)=>
  map = new Map
  for [k,v] from Object.entries obj
    map.set k, if v instanceof Function then [v,chain] else obj2map(v,chain)
  map


MAP = obj2map POST, [
  (o)=>
    if o != undefined then pack(o) else ''
]

export default MAP
