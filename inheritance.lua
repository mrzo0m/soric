pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

local function BaseClass(init)
    local self = {}

    local private_field = init

    function self.foo()
        return private_field
    end

    function self.bar()
        private_field = private_field + 1
    end

    -- return the instance
    return self
end

local function DerivedClass(init, init2)
    local self = BaseClass(init)

    self.public_field = init2

    -- this is independent from the base class's private field that has the same name
    local private_field = init2

    -- save the base version of foo for use in the derived version
    local base_foo = self.foo
    function self.foo()
        return private_field + self.public_field + base_foo()
    end

    -- return the instance
    return self
end

local i = DerivedClass(1, 2)
print(i.foo()) --> 5
i.bar()
print(i.foo()) --> 6




-----------
local BaseClass = {}
BaseClass.__index = BaseClass

setmetatable(BaseClass, {
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

function BaseClass:_init(init)
    self.value = init
end

function BaseClass:set_value(newval)
    self.value = newval
end

function BaseClass:get_value()
    return self.value
end

---

local DerivedClass = {}
DerivedClass.__index = DerivedClass

setmetatable(DerivedClass, {
    __index = BaseClass, -- this is what makes the inheritance work
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

function DerivedClass:_init(init1, init2)
    BaseClass._init(self, init1) -- call the base class constructor
    self.value2 = init2
end

function DerivedClass:get_value()
    return self.value + self.value2
end

local i = DerivedClass(1, 2)
print(i:get_value()) --> 3
i:set_value(3)
print(i:get_value()) --> 5