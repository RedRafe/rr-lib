local Public = {}

local Color = require_lib 'utils.color'

-- COLOR PROTOTYPES UTIL LIBRARY
--=============================================================================

-- ADD friendly color to a type of prototypes (e.g. radar, roboport...)
Public.type_friendly_color = function(source, color, friendly)
    local mode = (friendly == false and 'enemy_map_color') or 'friendly_map_color'
    if not color then
        return
    end
    local c = Color.parse(color)
    local s = data.raw[source]
    if not s then
        return
    end
    for _, e in pairs(s) do
        e[mode] = c
        e.map_color = c
    end
end

-- ADD friendly color to a specific entity
Public.entity_friendly_color = function(source, name, color, friendly)
    local mode = (friendly == false and 'enemy_map_color') or 'friendly_map_color'
    if not color then
        return
    end
    local c = Color.parse(color)
    local s = data.raw[source]
    if not s then
        return
    end
    local e = s[name]
    if not e then
        return
    end
    e[mode] = c
    e.map_color = c
end

-- ADD friendly color to all protptypes with that name
Public.friendly_color = function(name, color, friendly)
    local mode = (friendly == false and 'enemy_map_color') or 'friendly_map_color'
    if not color then
        return
    end
    local c = Color.parse(color)
    for _, source in pairs({
        'accumulator',
        'ammo-turret',
        'assembling-machine',
        'beacon',
        'boiler',
        'burner-generator',
        'container',
        'curved-rail',
        'electric-energy-interface',
        'electric-pole',
        'electric-turret',
        'fluid-turret',
        'furnace',
        'gate',
        'generator',
        'heat-pipe',
        'inserter',
        'lab',
        'loader-1x1',
        'loader',
        'logistic-container',
        'mining-drill',
        'pipe-to-ground',
        'pipe',
        'pump',
        'radar',
        'rail',
        'reactor',
        'roboport',
        'rocket-silo',
        'simple-entity',
        'solar-panel',
        'splitter',
        'storage-tank',
        'transport-belt',
        'tree',
        'underground-belt',
        'wall',
    }) do
        local e = data.raw[source] and data.raw[source][name]
        if e then
            e[mode] = c
            e.map_color = c
        end
    end
end

return Public
