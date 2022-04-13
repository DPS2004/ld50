local loc = {
  lang = "en",
  json=nil
}
function loc.load(j)
  loc.json = dpf.loadjson(j,{})
  print("localization file loaded")
end
function loc.setlang(l)
  loc.lang = l
  print("set language")
end
function loc.get(s,ins)
  
  local outstr = loc.lang .. "."..s
  if loc.json[s] then
    if loc.json[s][loc.lang] then
      outstr = loc.json[s][loc.lang]
    end
  end
  
  if ins then
    for i,v in ipairs(ins) do
      outstr = string.gsub(outstr,'@@'..tostring(i)..'@@',v)
    end
  end
  return outstr
end
return loc