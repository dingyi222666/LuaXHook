local base = {
  name = "lua"
}


local getmetatable = debug.getmetatable or getmetatable
local setmetatable = debug.setmetatable or setmetatable

base.setTableField = function(tab, field, target)
  rawset(tab, field, target)
end


base.generateListenerTable = function(originTable)
  local metatable = getmetatable(originTable) or {}
  if (metatable.__metatable_type == "LuaXHook") then
    return metatable, metatable.__origin_tanle
  end
  local target_metatable = {}

  target_metatable.__metatable_type = "LuaXHook"

  ---@TODO 添加支持多个响应
  target_metatable.setFieldEvent = function(field, func)
    if (not target_metatable.__field_event) then
      target_metatable.__field_event = {}
    end
    target_metatable.__field_event[field] = func
  end


  target_metatable.getFieldEvent = function(field)

    if (not target_metatable.__field_event) then
      return nil
    end
    return target_metatable.__field_event[field]
  end

  local target_table = {}

  target_metatable.__origin_tanle = originTable

  target_metatable.__metatable = metatable

  --接下来添加一个监听函数

  local function listener(event, ...)

    local eventType = 0
    if event == "__index" or event == "__newindex" then
      eventType = event == "__index" and 1 or 2
    end
    if eventType == 0 then
      if metatable[event] then
        return metatable[event](...)
      end
    end
    local old_metatable_event = metatable[event]
    local fakeOriginTable, fieldName, value = ...
    local eventFunction = target_metatable.getFieldEvent(fieldName)
    if eventType == 1 then
      
      local result = old_metatable_event or (function(_, fieldName) return rawget(originTable, fieldName) end)(originTable, fieldName)
      if (eventFunction ~= nil) then
        result =  eventFunction(fieldName, rawget(originTable,
          fieldName), originTable)
      end
      return result
    else
      if (eventFunction ~= nil) then
        return eventFunction(fieldName, rawget(originTable,
          fieldName), value, originTable)
      end
      return old_metatable_event or (function(originTable, fieldName, value) rawset(originTable, fieldName, value) end)(originTable, fieldName, value)
    end
  end

  local listenerEvents = base.utils.join(base.utils
    .keys(metatable or {}), "__index", "__newindex")

  for _, event in ipairs(listenerEvents) do
    target_metatable[event] = function(...)
      return listener(event, ...)
    end
  end
  setmetatable(target_table, target_metatable)
  return target_metatable, target_table
end

base.wrapperFunction = function(oldFunction, oldTable, targetFunction)
  return function(...)
    targetFunction(oldFunction, oldTable, ...)
  end
end

base.listenerProperty = function(fieldName, targetFieldTable, targetTablefieldName, targetTable)
  targetTable = targetTable or _G

  local fieldFunction = function(fieldName, oldValue, newValue, targetTable)
    local mode = targetTable == nil
    if (mode) then
      newValue = oldValue
      targetTable = newValue
    end
    if (mode) then
      pcall(
        targetFieldTable.get, fieldName, newValue, targetTable)
      return newValue
    else
      rawset(targetTable, fieldName, newValue)
      pcall(
        targetFieldTable.set, fieldName, oldValue, newValue, targetTable)

    end
  end
  local targetListenerTable = targetTable[targetTablefieldName]

  local metatable, result = base.generateListenerTable(targetListenerTable)
  metatable.setFieldEvent(fieldName, fieldFunction)
  targetTable[targetTablefieldName] = result
  return result
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
  rawset(targetTable, targetField, base.wrapperFunction(oldFunction, targetTable, targetFunction))
end

function base.hookFunction(targetField, targetTable, isNeedSelf)
  isNeedSelf = isNeedSelf or false
  targetTable = targetTable or _G
  local targetFunction = targetTable[targetField]
  return function(tab)
    base.setTableField(targetTable, targetField, function(...)
      local results = { (tab.afterCall or function(t, f, ...) end)(targetFunction, targetTable, ...) }
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

---@param api LuaXHookApiManage
base.init = function(_, api)
  --挂载辅助函数到自己的表去

  base.utils = api.utils
  local addToApiFunction = require "LuaXHook.emmylua.luaApi"


  for k, v in pairs(base) do

    if base.utils.find(addToApiFunction, k) ~= nil then
      api.addApi(k, v)
    end
  end


  --@TODO hook部分函数隐藏该框架
  --base.baseHiddenXposed()

end

return base
