---The file only used for complete the lua api in emmylua.
---@class xposedApi
local _M = {}

---@class xposedApi.xposedApiFunctionHookParams
local xposedApiFunctionHookParams = {}

--- Call this function before the target function is called.
---@param f function @The function to be hooked.
---@param t table @The table of the function.
---@vararg any @arguments of the function.
function xposedApiFunctionHookParams.beforeCall(f, t, ...) end

--- Call this function after the target function is called.
---@param f function @The function to be hooked.
---@param t table @The table of the function.
---@vararg any @arguments of the function.
function xposedApiFunctionHookParams.afterCall(f, t, ...) end

---@alias xposedApiFunctionHookParamsFunc fun(params:xposedApi.xposedApiFunctionHookParams)

---@alias xposedApiReplaceFunctionFunc fun(hookedFunction:function,hookedTable:table,params:...)

---@class xposedApi.xposedApiListenerPropertyParams
local xposedApiListenerPropertyParams = {}


--- Call this function when the target property in the target table is get.
---@param t table @The table of the property.
---@param n string @The name of the property.
---@param v any @The value of the property.
function xposedApiListenerPropertyParams.get(n, v, t) end

--- Call this function when the target property in the target table is set.
---@param t table @The table of the property.
---@param n string @The name of the property.
---@param o any @The old value of the property.
---@param e any @The new value of the property.
function xposedApiListenerPropertyParams.set(n, o, e, t) end

--- Find targetFunction in the targetTable And then hook it.
--- The `isNeedSelf` param is used to determine whether the targetFunction need self param.
---@param targetFunction function
---@param targetTable table|nil
---@param isNeedSelf boolean|nil @default false
---@return xposedApiFunctionHookParamsFunc
function _M.findAndHookFunction(targetFunction, targetTable, isNeedSelf) end

--- Hook a function in the targetTable.
--- Used targetField to find the targetFunction in the targetTable.
--- The  `isNeedSelf` param is used to determine whether the targetFunction need self param.
---@param targetField any
---@param targetTable table|nil
---@param isNeedSelf boolean|nil
function _M.hookFunction(targetField, targetTable, isNeedSelf) end

--- Replace the given function value in the table with the target function, you can do everything yourself with the parameters, which will have a higher level of customization than the `hookFunction` function.
---@see xposedApi#hookFunction
---@param targetField any
---@param targetFunction xposedApiReplaceFunctionFunc
---@param targetTable table|nil
function _M.replaceFunction(targetField, targetFunction, targetTable) end

--- Listener the target property in the target table.
---@param fieldName any
---@param targetTable table|nil
---@param targetFieldTable xposedApi.xposedApiListenerPropertyParams
---@param targetTablefieldName any
function _M.listenerProperty(fieldName, targetFieldTable, targetTablefieldName, targetTable)
end

local addToApiFunctions = {}

for name, v in pairs(_M) do
  table.insert(addToApiFunctions, name)
end

return addToApiFunctions
