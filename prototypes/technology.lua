local Public = {}

-- TECHNOLOGY PROTOTYPES UTIL LIBRARY
--=============================================================================

-- ADD a prerequisite to a given technology
Public.add_prerequisite = function(technology_name, prerequisite)
    local technology = data.raw.technology[technology_name]
    if not technology then
        return
    end
    for _, name in pairs(technology.prerequisites) do
        if name == prerequisite then
            return
        end
    end
    table.insert(technology.prerequisites, prerequisite)
end

-- REPLACE a prerequisite with another
Public.replace_prerequisite = function(technology_name, old, new)
    Public.remove_prerequisite(technology_name, old)
    Public.add_prerequisite(technology_name, new)
end

-- REMOVE a prerequisite from a given tech
Public.remove_prerequisite = function(technology_name, prerequisite)
    local technology = data.raw.technology[technology_name]
    if not technology then
        return
    end
    for i, name in pairs(technology.prerequisites or {}) do
        if name == prerequisite then
            table.remove(technology.prerequisites, i)
            return true
        end
    end
    return false
end

-- ADD science pack to a given tech
Public.add_research_ingredient = function(technology_name, ingredient)
    local technology = data.raw.technology[technology_name]
    if not technology then
        return
    end
    for _, name in pairs(technology.unit.ingredients) do
        if name[1] == ingredient then
            return
        end
    end
    table.insert(technology.unit.ingredients, { ingredient, 1 })
end

-- REPLACE a science pack with another
Public.replace_research_ingredient = function(technology_name, old, new)
    Public.remove_research_ingredient(technology_name, old)
    Public.add_research_ingredient(technology_name, new)
end

-- REMOVE science pack from a given tech
Public.remove_research_ingredient = function(technology_name, ingredient)
    local technology = data.raw.technology[technology_name]
    if not technology then
        return
    end
    for i, v in pairs(technology.unit.ingredients) do
        if v[1] and v[1] == ingredient then
            table.remove(technology.unit.ingredients, i)
        end
        if v.name and v.name == ingredient then
            table.remove(technology.unit.ingredients, i)
        end
    end
end

-- ADD an effect to a given technology
Public.add_effect = function(technology_name, effect)
    local technology = data.raw.technology[technology_name]
    if not technology then
        return
    end
    if not technology.effects then
        technology.effects = {}
    end
    if effect and effect.type == 'unlock-recipe' then
        if not data.raw.recipe[effect.recipe] then
            return
        end
        table.insert(technology.effects, effect)
    end
end

-- ADD an effect to a given technology to unlock recipe
Public.add_unlock = function(technology_name, recipe)
    Public.add_effect(technology_name, { type = 'unlock-recipe', recipe = recipe })
end

-- REMOVE recipe unlock effect from a given technology, multiple times if necessary
Public.remove_recipe_effect = function(technology_name, recipe_name)
    local technology = data.raw.technology[technology_name]
    if not technology then
        return
    end
    local index = -1
    local cnt = 0
    if technology and technology.effects then
        for i, effect in pairs(technology.effects) do
            if effect.type == 'unlock-recipe' and effect.recipe == recipe_name then
                index = i
                cnt = cnt + 1
            end
        end
        if index > -1 then
            table.remove(technology.effects, index)
            if cnt > 1 then -- not over yet, do it again
                Public.remove_recipe_effect(technology_name, recipe_name)
            end
        end
    end
end

return Public
