local base = {}

function base.addApi(name,func)
  base[name] = func
end

base.utils = {
  generateArgumentError = function(position,funcname,origintype,targettype)
    return 
    ("bad argument #%s to '%s' (%s expected, got %s)")
    :format(position,funcname,origintype,targettype)
  end,
  --TODO support basic lua53
  find = table.find
}

return base