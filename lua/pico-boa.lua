local M = {}

function M.setup()
    print("Hello Pico-Boa from lua!")
end

function M.find_devices()
    local command = "ls /dev/tty.*"
    local handle = io.popen(command)
    if handle == nil then
        return ""
    else
        local result = handle:read("*a")
        handle:close()
        return result
    end
end

function M.start_serial_session(device)
    local command = "screen " .. device
    os.execute(command)
end

return M

