require "import"

---@type xposedApi
local xposed = require "LuaXHook" {
  lua = "the basic hook support"
}

dump = dump or function(any) end

--[[ xposed.findAndHookFunction(dump) {
  beforeCall = function(f, t, ...)
    print("beforeHook", f, t, ...)
  end,
  afterCall = function(f, t, ...)
    print("afterHook", f, t, ...)
  end
}
 ]]

--[[ xposed
.replaceFunction("print", function(oldFunction,oldTable,...)
  oldFunction("replace", ...)
end) ]]

a = { "1", "2", "3" }

xposed
.listenerProperty(1,{
  get = function (name, value)
    print("get", name, value)
    return value
  end,
  set = function (name, oldValue, newValue)
    print("set", name, oldValue, newValue)
  end
},"a")

print(dump(xposed))

local s = a[1]
a[1] = "4"
print(a[1])
