require "import"

---@type xposedApi
local xposed = require "LuaXHook" {
  lua = "the basic hook support"
}

dump = dump or function(any) end

xposed.findAndHookFunction(dump) {
  beforeCall = function(f, t, ...)
    print("beforeHook", f, t, ...)
  end,
  afterCall = function(f, t, ...)
    print("afterHook", f, t, ...)
  end
}



xposed
.replaceFunction("print", function(oldFunction,oldTable,...)
  oldFunction("replace", ...)
end)

print(dump(xposed))