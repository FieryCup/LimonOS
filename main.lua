
local monitor = peripheral.find('monitor')
local rs = peripheral.find('rsBridge')
local speaker = peripheral.find("speaker")
local width, height = monitor.getSize()
local space = " "
local default_bg_color = colors.black
local list_size = 36
local list_horizontal_space = 2
local progressbar_size = 20
local reboot_button_size = 3
local title = "RS Info"
reboot_button_size = reboot_button_size - 1
monitor.setTextColor(colors.white)
monitor.setBackgroundColor(default_bg_color)
monitor.setTextScale(0.75)
monitor.clear()

local win_rs_info = window.create(monitor, 1, 1, width, height)

function progressbar(n, max, color, warningColor, fullColor, secondColor, size, screen)
    local bar = math.floor((n / max) * size)
    local bar_inv = size - bar
    local bar_text = string.rep(space, bar)
    local bar_text_inv = string.rep(space, bar_inv)
    if bar < size / 2 then
        screen.setBackgroundColor(color)
    elseif bar < size / 1.25 then
        screen.setBackgroundColor(warningColor)
    else
        screen.setBackgroundColor(fullColor)
    end
    screen.write(bar_text)
    screen.setBackgroundColor(secondColor)
    screen.write(bar_text_inv)
end
--[[
function rsbridge_nf_error()
    monitor.setTextScale(2.5)
    monitor.setBackgroundColor(red)
    monitor.setTextColor(colors.white)
    monitor.write("Error! RS Bridge not found. ")
    print("Error! RS Bridge not found. ")
end
]]--

function rs_info(screen)
    screen.setCursorPos(((width / 2) - (string.len(title) / 2)), 1)
    screen.write(title)
    screen.setCursorPos(1, 2)
    screen.write("Energy:       ")
    screen.write(progressbar(rs.getEnergyStorage(), rs.getMaxEnergyStorage(), colors.red, colors.orange, colors.green, colors.gray, progressbar_size, screen))
    screen.setBackgroundColor(default_bg_color)
    screen.write(" "..rs.getEnergyStorage().." / "..rs.getMaxEnergyStorage().." "..rs.getEnergyUsage().." FE/t".."               ")
    screen.setCursorPos(1, 3)
    list = rs.listItems()
    local item_count = 0
    for i, item in ipairs(list) do
        item_count = item_count + item.amount
    end
    screen.write("Item memory:  ")
    screen.write(progressbar(item_count, rs.getMaxItemDiskStorage(), colors.green, colors.orange, colors.red, colors.gray, progressbar_size, screen))
    screen.setBackgroundColor(default_bg_color)
    screen.write(" "..item_count.." / "..rs.getMaxItemDiskStorage().."               ")
    screen.setCursorPos(1, 4)
    fluid_list = rs.listFluids()
    local fluid_count = 0
    for i, fluid in ipairs(fluid_list) do
        fluid_count = fluid_count + fluid.amount
    end
    if math.floor((item_count / rs.getMaxItemDiskStorage()) * 100) > 100 / 1.25 then
        speaker.playSound("minecraft:block.bell.use")
    end
    screen.write("Fluid memory: ")
    screen.write(progressbar(fluid_count, rs.getMaxFluidDiskStorage(), colors.green, colors.orange, colors.red, colors.gray, progressbar_size, screen))
    screen.setBackgroundColor(default_bg_color)
    screen.write(" "..fluid_count.." / "..rs.getMaxFluidDiskStorage().."               ")
    screen.setCursorPos(1, 4)
    list = rs.listItems()
    table.sort(list, function(a,b) return a.amount > b.amount end)
    local list_size_h = 0
    for i, item in ipairs(list) do
        local o = string.sub(item.displayName, 5, string.len(item.displayName)-1)
        k = string.len(o)
        if list_size_h < k then
            list_size_h = string.len(o)
        end
    end
    local g = 1
    local k = 1
    local h = 5
    local list_height = height - 2
    for i, item in ipairs(list) do
        o = string.sub(item.displayName, 5, string.len(item.displayName)-1)
        if g >= list_height then
            k = k + list_size_h
            h = 5
            g = 1
        end
        screen.setCursorPos(k, h)
        screen.setTextColor(colors.gray)
        screen.write(o)
        screen.setTextColor(colors.white)
        local o = string.sub(item.displayName, 5, string.len(item.displayName)-1)
        screen.write(string.rep(space, (list_size_h - list_horizontal_space - string.len(item.amount) - string.len(o))))
        screen.write(tostring(item.amount)..string.rep(space, list_horizontal_space))
        g = g + 1
        h = h + 1
    end
    screen.setBackgroundColor(colors.red)
    screen.setTextColor(colors.black)
    screen.setCursorPos(width - reboot_button_size, 1)
    screen.write("   ")
    screen.setCursorPos(width - reboot_button_size, 2)
    screen.write(" X ")
    screen.setCursorPos(width - reboot_button_size, 3)
    screen.write("   ")
    screen.setTextColor(colors.white)
    screen.setBackgroundColor(default_bg_color)
    local event, side, xPos, yPos = os.pullEvent("monitor_touch")
    if event == "monitor_touch" and (xPos >= width - reboot_button_size) and (yPos <= reboot_button_size + 1) then
        print("Pressed")
        screen.clear()
        os.reboot()
    end
end

while true do
    win_rs_info_visible = 1
    if win_rs_info_visible == 1 then
        win_rs_info.setVisible(true)
    else
        win_rs_info.setVisible(false)
    end
    win_rs_info(win_rs_info)
    sleep(1)
end