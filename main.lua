
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

function progressbar(n, max, color, warningColor, fullColor, secondColor, size)
    local bar = math.floor((n / max) * size)
    local bar_inv = size - bar
    local bar_text = string.rep(space, bar)
    local bar_text_inv = string.rep(space, bar_inv)
    if bar < size / 2 then
        monitor.setBackgroundColor(color)
    elseif bar < size / 1.25 then
        monitor.setBackgroundColor(warningColor)
    else
        monitor.setBackgroundColor(fullColor)
    end
    monitor.write(bar_text)
    monitor.setBackgroundColor(secondColor)
    monitor.write(bar_text_inv)
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
while true do
    monitor.setCursorPos(((width / 2) - (string.len(title) / 2)), 1)
    monitor.write(title)
    monitor.setCursorPos(1, 2)
    monitor.write("Energy:       ")
    monitor.write(progressbar(rs.getEnergyStorage(), rs.getMaxEnergyStorage(), colors.red, colors.orange, colors.green, colors.gray, progressbar_size))
    monitor.setBackgroundColor(default_bg_color)
    monitor.write(" "..rs.getEnergyStorage().." / "..rs.getMaxEnergyStorage().." "..rs.getEnergyUsage().." FE/t".."               ")
    monitor.setCursorPos(1, 3)
    list = rs.listItems()
    local item_count = 0
    for i, item in ipairs(list) do
        item_count = item_count + item.amount
    end
    monitor.write("Item memory:  ")
    monitor.write(progressbar(item_count, rs.getMaxItemDiskStorage(), colors.green, colors.orange, colors.red, colors.gray, progressbar_size))
    monitor.setBackgroundColor(default_bg_color)
    monitor.write(" "..item_count.." / "..rs.getMaxItemDiskStorage().."               ")
    monitor.setCursorPos(1, 4)
    fluid_list = rs.listFluids()
    local fluid_count = 0
    for i, fluid in ipairs(fluid_list) do
        fluid_count = fluid_count + fluid.amount
    end
    if math.floor((item_count / rs.getMaxItemDiskStorage()) * 100) > 100 / 1.25 then
        speaker.playSound("minecraft:block.bell.use")
    end
    monitor.write("Fluid memory: ")
    monitor.write(progressbar(fluid_count, rs.getMaxFluidDiskStorage(), colors.green, colors.orange, colors.red, colors.gray, 20))
    monitor.setBackgroundColor(default_bg_color)
    monitor.write(" "..fluid_count.." / "..rs.getMaxFluidDiskStorage().."               ")
    monitor.setCursorPos(1, 4)
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
        monitor.setCursorPos(k, h)
        monitor.setTextColor(colors.gray)
        monitor.write(o)
        monitor.setTextColor(colors.white)
        local o = string.sub(item.displayName, 5, string.len(item.displayName)-1)
        monitor.write(string.rep(space, (list_size_h - list_horizontal_space - string.len(item.amount) - string.len(o))))
        monitor.write(tostring(item.amount)..string.rep(space, list_horizontal_space))
        g = g + 1
        h = h + 1
    end
    monitor.setBackgroundColor(colors.red)
    monitor.setTextColor(colors.black)
    monitor.setCursorPos(width - reboot_button_size, 1)
    monitor.write("   ")
    monitor.setCursorPos(width - reboot_button_size, 2)
    monitor.write(" X ")
    monitor.setCursorPos(width - reboot_button_size, 3)
    monitor.write("   ")
    monitor.setTextColor(colors.white)
    monitor.setBackgroundColor(default_bg_color)
    local event, side, xPos, yPos = os.pullEvent("monitor_touch")
    if event == "monitor_touch" and (xPos >= width - reboot_button_size) and (yPos <= reboot_button_size + 1) then
        print("Pressed")
        monitor.clear()
        os.reboot()
    end
    sleep(1)
end