-- GLOBALS
--=============================================================================

_DEBUG = false

-- Route all requires to full mod paths
---@param path string
require_lib = function(path)
    return require('__rr-lib__.' .. path)
end

-- CORE LIBRARY
--=============================================================================

local Public = {}

-- Safely appends modules to the root module
---@param root table
---@param paths string[], filepaths
Public.extend = function(root, paths)
    if type(paths) == 'string' then
        paths = { paths }
    end
    for _, path in pairs(paths) do
        for k, v in pairs(require_lib(path)) do
            if root[k] ~= nil then
                error(string.format('Trying to override lib function %s from %s', k, path))
            end
            root[k] = v
        end
    end
end

---@param obj any
Public.print = function(obj)
    if not _DEBUG then
        return
    end

    if type(obj) == 'string' or type(obj) == 'number' or type(obj) == 'boolean' then
        log(obj)
    else
        log(serpent.block(obj))
    end
end

return Public
