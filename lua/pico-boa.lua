local M = {}

local function get_self_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end

local function compile_c(path_to_c)
    local command = "gcc " .. path_to_c .. "main.c" .. " -o " .. path_to_c .. "usb.bin"
    os.execute(command)
end

local function test()
    vim.cmd('')
end

function M.setup()
    local path = get_self_path()
    path = path:sub(1, -2):match("(.*/)") .. "c/"
    compile_c(path)
    local val = vim.fn.input("Enter baud rate: ")
    local command = path .. "usb.bin " .. val
--    print("Setting up")
    print(command)
    local handle, err = io.popen(command)
    if not handle then
        print(err)
        return
    end
    local result = handle:read("*all")
    print(result)
    print(tonumber(result) * 2)
    handle:close()
end

local function split_at_newline(str)
    local result = {}
    for line in str:gmatch("[^\r\n]+") do
        table.insert(result, line)
    end
    return result
end

function M.find_devices()
    local command = "ls /dev/tty.*"
    local handle = io.popen(command)
    if handle == nil then
        return ""
    else
        local result = handle:read("*a")
        handle:close()
        return split_at_newline(result)
    end
end

function M.start_serial_session(device)
    local command = "screen -dmS " .. device .. " -d"
    os.execute(command)
end

local function print_enumerated(tab)
    for i, v in ipairs(tab) do
        print(i .. ": " .. v)
    end
end

function M.start_serial_session_by_id()
    local devs = M.find_devices()
    print_enumerated(devs)
    local id = vim.fn.input("Select device: ")
    local device = devs[tonumber(id)]
    print("Starting session on " .. device)
    M.start_serial_session(device)
end

return M

