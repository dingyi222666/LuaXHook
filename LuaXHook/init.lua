local api = require "LuaXHook.api"

local platforms = require "LuaXHook.platform"

return function(option)
  for name,v in pairs(option) do
    platforms
    .addPlatfrom(name,option,api)
  end
  return api
end