-- luacheck: ignore data
-- luacheck: ignore script

_G.rr = require '__rr-lib__.utils.__init__'

-- rr LIBRARY
--=============================================================================

require_lib 'utils.math'
require_lib 'utils.string'
require_lib 'utils.table'

if data and data.raw and not data.raw.item then
    rr.stage = 'settings'
elseif data and data.raw then
    rr.stage = 'data'
    rr:extend {
        'prototypes.shared',
        'prototypes.color',
        'prototypes.recipe',
        'prototypes.technology',
    }
elseif script then
    rr.stage = 'control'
    rr:extend {
        'scripts.event',
        'scripts.storage',
        'scripts.task',
        'scripts.token',
    }
else
    error('Could not determine load order stage.')
end
