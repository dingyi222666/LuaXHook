require "import"

local xposed = require "LuaXHook" {
  lua = "the basic hook support" 
}

xposed.findAndHookFuction(dump) {
  beforeCall = function(f,t,...)
    print("before call...",...)
  end,
  afterCall= function(f,t,...)
    print("after call...",...)
  end
}

print(dump(xposed))