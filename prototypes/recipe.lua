local Public = {}

-- RECIPE PROTOTYPES UTIL LIBRARY
--=============================================================================

local function has_ingredient(recipe, ingredient)
    if recipe ~= nil and recipe.ingredients ~= nil then
        for i, existing in pairs(recipe.ingredients) do
            if existing[1] == ingredient or existing.name == ingredient then
                return true
            end
        end
    end
    return false
end

local function add_ingredient(recipe, ingredient, quantity, is_fluid)
    if recipe ~= nil and recipe.ingredients ~= nil then
        for i, existing in pairs(recipe.ingredients) do
            if existing[1] == ingredient or existing.name == ingredient then
                return
            end
        end
        if is_fluid then
            table.insert(recipe.ingredients, { type = 'fluid', name = ingredient, amount = quantity })
        else
            table.insert(recipe.ingredients, { type = 'item', name = ingredient, amount = quantity })
        end
    end
end

local function replace_ingredient(recipe, old, new, amount, multiply)
    if recipe ~= nil and recipe.ingredients ~= nil then
        for i, existing in pairs(recipe.ingredients) do
            if existing[1] == new or existing.name == new then
                if existing.amount then
                    existing.amount = amount
                end
                if existing[2] then
                    existing[2] = amount
                end
                return
            end
        end
        for i, ingredient in pairs(recipe.ingredients) do
            if ingredient.name == old then
                ingredient.name = new
                if amount then
                    if multiply then
                        ingredient.amount = amount * ingredient.amount
                    else
                        ingredient.amount = amount
                    end
                end
            end
            if ingredient[1] == old then
                ingredient[1] = new
                if amount then
                    if multiply then
                        ingredient[2] = amount * ingredient[2]
                    else
                        ingredient[2] = amount
                    end
                end
            end
        end
    end
end

local function remove_ingredient(recipe, old)
    local index = -1
    if recipe ~= nil and recipe.ingredients ~= nil then
        for i, ingredient in pairs(recipe.ingredients) do
            if ingredient.name == old or ingredient[1] == old then
                index = i
                break
            end
        end
        if index > -1 then
            table.remove(recipe.ingredients, index)
        end
    end
end

local function multiply_recipe(recipe, multiple)
    if recipe then
        if recipe.energy_required then
            recipe.energy_required = recipe.energy_required * multiple
        else
            recipe.energy_required = 0.5 * multiple -- 0.5 is factorio default
        end
        if recipe.result_count then
            recipe.result_count = recipe.result_count * multiple
        end
        if recipe.results then
            for i, result in pairs(recipe.results) do
                if result.name then
                    if result.amount then
                        result.amount = result.amount * multiple
                    end
                    if result.amount_min ~= nil then
                        result.amount_min = result.amount_min * multiple
                        result.amount_max = result.amount_max * multiple
                    end
                    if result.catalyst_amount then
                        result.catalyst_amount = result.catalyst_amount * multiple
                    end
                end
                if result[1] then
                    result[2] = result[2] * multiple
                end
            end
        end
        if not recipe.results and not recipe.result_count then
            -- implicit one item result
            recipe.result_count = multiple
        end
        if recipe.ingredients then
            for i, ingredient in pairs(recipe.ingredients) do
                if ingredient.name then
                    ingredient.amount = ingredient.amount * multiple
                end
                if ingredient[1] then
                    ingredient[2] = ingredient[2] * multiple
                end
            end
        end
    end
end

-- ============================================================================

-- REMOVE all instances of unlocks for a given recipe
Public.remove_all_recipe_effects = function(recipe_name)
    for name, _ in pairs(data.raw.technology) do
        Public.remove_recipe_effect(name, recipe_name)
    end
end

-- MOVE an unlock from a technology to another
Public.move_recipe_unlock = function(recipe_name, old, new)
    Public.remove_recipe_effect(old, recipe_name)
    Public.add_unlock(new, recipe_name)
end

-- ADD recipe to productivity whitelisted limitations
Public.whitelist_productivity = function(recipe_name)
    local recipe = data.raw.recipe[recipe_name]
    if recipe then
        recipe.allow_productivity = true
    end
end

-- Returns true if a recipe has an ingredient
Public.has_ingredient = function(recipe_name, ingredient)
    return data.raw.recipe[recipe_name] and (has_ingredient(data.raw.recipe[recipe_name], ingredient) or has_ingredient(data.raw.recipe[recipe_name].normal, ingredient))
end

-- ADD a given quantity of ingredient to target recipe
Public.add_ingredient = function(recipe_name, ingredient, quantity)
    local is_fluid = not not data.raw.fluid[ingredient]
    if data.raw.recipe[recipe_name] and (data.raw.item[ingredient] or is_fluid) then
        add_ingredient(data.raw.recipe[recipe_name], ingredient, quantity, is_fluid)
        add_ingredient(data.raw.recipe[recipe_name].normal, ingredient, quantity, is_fluid)
        add_ingredient(data.raw.recipe[recipe_name].expensive, ingredient, quantity, is_fluid)
    end
end

-- REPLACE one ingredient with another in a recipe
--    Use amount to set an amount. If that amount is a multiplier instead of an exact amount, set multiply true.
Public.replace_ingredient = function(recipe_name, old, new, amount, multiply)
    if data.raw.recipe[recipe_name] and (data.raw.item[new] or data.raw.fluid[new]) then
        replace_ingredient(data.raw.recipe[recipe_name], old, new, amount, multiply)
        replace_ingredient(data.raw.recipe[recipe_name].normal, old, new, amount, multiply)
        replace_ingredient(data.raw.recipe[recipe_name].expensive, old, new, amount, multiply)
    end
end

-- REMOVE an ingredient from a recipe
Public.remove_ingredient = function(recipe_name, old)
    if data.raw.recipe[recipe_name] then
        remove_ingredient(data.raw.recipe[recipe_name], old)
        remove_ingredient(data.raw.recipe[recipe_name].normal, old)
        remove_ingredient(data.raw.recipe[recipe_name].expensive, old)
    end
end

-- MULTIPLY the cost, energy, and results of a recipe by a multiple
Public.multiply_recipe = function(recipe_name, multiple)
    if data.raw.recipe[recipe_name] then
        multiply_recipe(data.raw.recipe[recipe_name], multiple)
        multiply_recipe(data.raw.recipe[recipe_name].normal, multiple)
        multiply_recipe(data.raw.recipe[recipe_name].expensive, multiple)
    end
end

return Public
