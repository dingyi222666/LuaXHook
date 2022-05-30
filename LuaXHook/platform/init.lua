local base = {}


local all_platform = {
  require "LuaXHook.platform.lua"
}

base.addPlatfrom = function(name,option,api)
  local target_platform
  for k,v in ipairs(all_platform) do
    
    if v.name == name then
      target_platform = v
      break
    end
  end
  if target_platform == nil then
    error(("Can't find %s platform suport"):format(name))
  end
  target_platform.init(option,api)
end

return base