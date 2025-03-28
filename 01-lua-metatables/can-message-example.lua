CANMessage = {} ---Instantiate the base class
CANMessage.__index = CANMessage --- Have it reference itself
function CANMessage:new(id, name, data_fields, update_freq) -- val_updater() ensures fresh values every time when using AP API
    local instance = {                                              --object properties for each different CAN Message
        _id = id,
        _name = name,
        _data_fields = data_fields,
        _values = {},
        _update_freq = update_freq,
        _last_sent = 0,                                              --set to zero so that you don't get a null error
        _callback_fn = nil, --function that is realised in the instances, specific to the sensor type and what the sensor function returns
    }
    setmetatable(instance, CANMessage)
    return instance
end

function CANMessage:register_callback(callback_fn)
    if (type(callback_fn) == "function") then
        print("Callback registered for ".. self._name)
        self._callback_fn = callback_fn
        return true
    else
        print("Callback fails to register for ".. self._name.. " <function> type expected but passed argument is ".. type(callback_fn))
    end
    -- If it ever gets here, then assume that it fails
    return false
end

function CANMessage:build_fields()
    if (self._callback_fn ~= nil) then
        local updated_values = self:_callback_fn()
        -- Do something with your returned values
        print(updated_values[1])
        print(updated_values[2])
        print(updated_values[3])
    else
        print("Invalid function callback. Callback function is nil")
    end
end

local vib_id = 0x10
local vib_update = 1000

VibrationData = {}
function VibrationData:new()
    VibrationData.__index = CANMessage
    setmetatable(VibrationData, {__index = CANMessage})
    local instance = CANMessage:new(vib_id, "Vibration",
            { --Vibration data message + spool_state
                {bits=16, start_bit=0, scale=100, signed=false},
                {bits=16, start_bit=16, scale=100, signed=false},
                {bits=16, start_bit=32, scale=100, signed=false},
                {bits=16, start_bit=48, scale=1, signed=false}
            },
            vib_update
    )
    instance.i = 0
    setmetatable(instance, {__index = VibrationData})
    return instance
end

function VibrationData:callback()
    return {10, 20, 30}
end

local vibration_data = VibrationData:new()
local wrong_callback = "example"
local status = vibration_data:register_callback(wrong_callback)
vibration_data:build_fields()
