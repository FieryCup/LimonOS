
local monitor = peripheral.find('monitor')
local rs = peripheral.find('rsBridge')
local speaker = peripheral.find("speaker")
monitor.setTextScale(0.5)
local width_monitor, height_monitor = monitor.getSize()
local space = " "
local default_bg_color = colors.black
local desktop_bg_color = colors.gray
local list_size = 36
local list_horizontal_space = 2
local progressbar_size = 20
local reboot_button_size = 3
local title = "RS Info"
local visible = "Desktop"
local RSInfo_logo_x = 1
local RSInfo_logo_y = 1
color = {
    c1 = colors.black,
    c2 = colors.blue,
    c3 = colors.brown,
    c4 = colors.cyan,
    c5 = colors.gray,
    c6 = colors.green,
    c7 = colors.lightBlue,
    c8 = colors.lightGray,
    c9 = colors.lime,
    c10 = colors.magenta,
    c11 = colors.orange,
    c12 = colors.pink,
    c13 = colors.purple,
    c14 = colors.red,
    c15 = colors.white,
    c16 = colors.yellow
}
reboot_button_size = reboot_button_size - 1
monitor.setTextColor(colors.white)
monitor.setBackgroundColor(default_bg_color)
monitor.clear()

local win_rs_info = window.create(monitor, 1, 1, width_monitor, height_monitor)
local win_desktop = window.create(monitor, 1, 1, width_monitor, height_monitor)

function progressbar(n, max, color, warningColor, fullColor, secondColor, size, screen)
    local bar = math.floor((n / max) * size)
    local bar_inv = size - bar
    local space = " "
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
    screen.setBackgroundColor(default_bg_color)
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
--Rs_info
function rs_info(screen)
    local width_screen, height_screen = screen.getSize()
    screen.setCursorPos(((width_screen / 2) - (string.len(title) / 2)), 1)
    screen.write(title)
    screen.setCursorPos(1, 2)
    screen.write("Energy:       ")
    progressbar(rs.getEnergyStorage(), rs.getMaxEnergyStorage(), colors.red, colors.orange, colors.green, colors.gray, progressbar_size, screen)
    screen.setBackgroundColor(default_bg_color)
    screen.write(" "..rs.getEnergyStorage().." / "..rs.getMaxEnergyStorage().." "..rs.getEnergyUsage().." FE/t".."               ")
    screen.setCursorPos(1, 3)
    list = rs.listItems()
    local item_count = 0
    for i, item in ipairs(list) do
        item_count = item_count + item.amount
    end
    screen.write("Item memory:  ")
    progressbar(item_count, rs.getMaxItemDiskStorage(), colors.green, colors.orange, colors.red, colors.gray, progressbar_size, screen)
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
    progressbar(fluid_count, rs.getMaxFluidDiskStorage(), colors.green, colors.orange, colors.red, colors.gray, progressbar_size, screen)
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
    local list_height = height_screen - 2
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
    screen.setCursorPos(width_screen - reboot_button_size, 1)
    screen.write("   ")
    screen.setCursorPos(width_screen - reboot_button_size, 2)
    screen.write(" X ")
    screen.setCursorPos(width_screen - reboot_button_size, 3)
    screen.write("   ")
    screen.setTextColor(colors.white)
    screen.setBackgroundColor(default_bg_color)
end

--Desktop
function drawRsInfoIcon(x, y, screen)
    local RsInfoIcon = {
        {desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color},
        {desktop_bg_color, desktop_bg_color, colors.yellow, colors.yellow, colors.yellow, colors.yellow, colors.yellow, colors.yellow, desktop_bg_color, desktop_bg_color},
        {desktop_bg_color, desktop_bg_color, colors.orange, colors.orange, colors.yellow, colors.yellow, colors.orange, colors.orange, desktop_bg_color, desktop_bg_color},
        {desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color, colors.yellow, colors.yellow, desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color},
        {desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color, colors.yellow, colors.yellow, desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color},
        {desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color, colors.yellow, colors.yellow, desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color},
        {desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color, colors.yellow, colors.yellow, desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color},
        {desktop_bg_color, desktop_bg_color, colors.yellow, colors.yellow, colors.yellow, colors.yellow, colors.yellow, colors.yellow, desktop_bg_color, desktop_bg_color},
        {desktop_bg_color, desktop_bg_color, colors.orange, colors.orange, colors.orange, colors.orange, colors.orange, colors.orange, desktop_bg_color, desktop_bg_color},
        {desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color, desktop_bg_color}}
    screen.setBackgroundColor(colors.gray)
    local icon_size = 0
    for i, k in ipairs(RsInfoIcon) do
        for j, l in ipairs(k) do
            screen.setCursorPos(j+x, i+y)
            screen.setBackgroundColor(l)
            screen.write(space)
            icon_size = j
        end
    end
    screen.setBackgroundColor(desktop_bg_color)
    screen.setCursorPos(x+(icon_size+2), y+math.floor(icon_size/2))
    screen.write("Rs Info")
end

function desktop(screen)
    drawRsInfoIcon(RSInfo_logo_x, RSInfo_logo_y, screen)
end

--Main loop
while true do
    if visible == "RS Info" then
        rs_info(win_rs_info)
        win_rs_info.setVisible(true)
        win_desktop.setVisible(false)
        print("RS Info")
        local width_screen, height_screen = win_rs_info.getSize()
        local event, side, xPos, yPos = os.pullEvent("monitor_touch")
        if event == "monitor_touch" and (xPos >= width_screen - reboot_button_size) and (yPos <= reboot_button_size + 1) then
            visible = "Desktop"
        end
    elseif visible == "Desktop" then
        print("1-2")
        desktop(win_desktop)
        print("1-3")
        win_desktop.setVisible(true)
        win_rs_info.setVisible(false)
        print("Desktop")
        local event, side, xPos, yPos = os.pullEvent("monitor_touch")
        if event == "monitor_touch" and (((xPos >= RSInfo_logo_x) and (xPos < RSInfo_logo_x + 10)) and ((yPos >= RSInfo_logo_y) and (yPos < RSInfo_logo_y + 10))) then
            visible = "RS Info"
        end
    end
    sleep(1)
end