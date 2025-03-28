Base = {}
function Base:new(id, name)
    local self = {}
    self._id = id
    self._name = name
    self._fn_callback = nil
    setmetatable(self, {__index = Base})
    print("Base constructed!")
    return self
end

function Base:register_callback(function_callback)
    if (type(function_callback) == "function") then
        self._fn_callback = function_callback
    else
        print("function_callback is not a function! Instead ".. type(function_callback) .. "has been passed.")
    end 
end

function Base:get_id()
    return self._id
end

function Base:get_name()
    return self._name
end

-- Please read the Child class from this StackOverflow discussion to understand how the metatables work
-- https://stackoverflow.com/questions/65961478/how-to-mimic-simple-inheritance-with-base-and-child-class-constructors-in-lua-t
Child = {}
-- Child.__index = DerivedMetatable
function Child:new(id, name)
    -- We assign the Child's metable to Base metatable so we can ensure the interpreter can find the right keys to the Base
    -- metatable ("class")
    Child.__index = Base
    setmetatable(Child, {__index = Base})
    -- Now we also inherit all properties of Base (e.g. _id, _name) by using the self.<property_name>
    local self = Base:new(id, name)
    setmetatable(self, {__index = Child})
    print("Child constructed!")
    print("The ID has been set to ".. self._id .." with name ".. self._name)
    return self
end

function Child:callback()
    print("Inside Child Callback")
end

local test = Child:new(0x10, "Vibration")
test:callback()
