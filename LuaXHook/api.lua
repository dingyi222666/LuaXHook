---@class LuaXHookApiManage
local base = {}

function base.addApi(name, func)
  base[name] = func
end

base.utils = {
  generateArgumentError = function(position, funcname, origintype, targettype)
    return ("bad argument #%s to '%s' (%s expected, got %s)")
        :format(position, funcname, origintype, targettype)
  end,
  find = table.find or function(targetTable, value)
    for k, v in pairs(targetTable) do
      if v == value then
        return k
      end
    end
  end,
  ---@param tab table
  keys = function(tab)
    local keys = {}
    for k, v in pairs(tab) do
      table.insert(keys, k)
    end
    return keys
  end,
  join = function(tab, ...)
    local result = {}
    for _, v in ipairs(tab) do
      table.insert(result, v)
    end
    for _, v in ipairs { ... } do
      table.insert(result, v)
    end
    return result
  end
}

return base
