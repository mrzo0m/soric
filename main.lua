pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- soric main

function getmyclass()
    local myclass = {} -- the table representing the class, which will double as the metatable for the instances
    myclass.__index = myclass -- failed table lookups on the instances should fallback to the class table, to get methods

    -- syntax equivalent to "myclass.new = function..."
    function myclass.new(init)
        local self = setmetatable({}, myclass)
        self.value = init
        return self
    end

    function myclass.set_value(self, newval)
        self.value = newval
    end

    function myclass.get_value(self)
        return self.value
    end
    return myclass
end


