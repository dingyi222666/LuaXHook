local base = {
  name = "lua"
}


base.setTableField = function(tab, field, target)
  rawset(tab, field, target)
end


base.findAndHookFunction = function(targetFunction, targetTable, isNeedSelf)
  isNeedSelf = isNeedSelf or false
  targetTable = targetTable or _G
  local targetField = base.utils.find(targetTable, targetFunction)

  return base.hookFunction(targetField, targetTable, isNeedSelf)
end

function base.replaceFunction(targetField, targetFunction, targetTable)
  targetTable = targetTable or _G
  local oldFunction = rawget(targetTable, targetField)
  local wrapperTargetFunction = function(...)
    return targetFunction(oldFunction,targetTable, ...)
  end
  rawset(targetTable, targetField, wrapperTargetFunction)
end

function base.hookFunction(targetField, targetTable, isNeedSelf)
  isNeedSelf = isNeedSelf or false
  targetTable = targetTable or _G
  local targetFunction = targetTable[targetField]
  return function(tab)
    base.setTableField(targetTable, targetField, function(...)
      local results = { (tab.afterCall or function() end)(targetFunction, targetTable, ...) }
      if #results == 0 then
        results = { ... }
      end
      if isNeedSelf then
        results = {
          targetFunction(targetTable, table.unpack(results))
        }
      else
        results = {
          targetFunction(table.unpack(results))
        }
      end
      local before_results = { (tab.beforeCall or function(t, f, ...) return ... end)(targetFunction, targetTable,
        table.unpack(results)) }
      if #before_results > 0 then
        results = before_results
      end
      return table.unpack(results)
    end)
  end

end

base.init = function(_, api)
  --挂载辅助函数到自己的表去

  base.utils = api.utils
  local addToApiFunction = require "LuaXHook.emmylua.luaApi"


  for k, v in pairs(base) do

    if base.utils.find(addToApiFunction, k) ~= nil then
      api.addApi(k, v)
    end

  end
end

return base
