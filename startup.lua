
local monitor = peripheral.find('monitor')
local speaker = peripheral.find("speaker")
local width, height = monitor.getSize()
local space = " "
local source_startup = "https://raw.githubusercontent.com/LimonchikTM/LimonOS/main/startup.lua"
local source_main = "https://raw.githubusercontent.com/LimonchikTM/LimonOS/main/main.lua"
local source_version = "https://raw.githubusercontent.com/LimonchikTM/LimonOS/main/version.lua"
local text_color = colors.yellow
local second_text_color = colors.white
local message_text_color = colors.gray
local text_scale = 1.5
monitor_text_scale = text_scale / 100 * width
if monitor_text_scale < 0.5 then
    monitor_text_scale = 0.5
end
if monitor_text_scale > 5 then
    monitor_text_scale = 5
end
monitor.setTextScale(monitor_text_scale)
speaker.playSound("minecraft:block.note_block.bit")
local subtitle_list_count = 7
local subtitle_list = {
    "Maybe a cup of tea?", 
    "Lucy, tea!",
    "Well planned - half done.", 
    "Every word has a meaning ...",
    "Life is always happening now.",
    "We are ripples in time.",
    "Life requires movement.",
}
local bg_color = colors.black
local title = "Limonchik's Software"
local width, height = monitor.getSize()

function autoupdate()
    monitor.setTextColor(message_text_color)
    local source_status, _ = http.checkURL(source_main)
    monitor.setCursorPos(1, height)
    monitor.write("Source check ... "..tostring(source_status))
    if source_status == false then
        monitor.setCursorPos(1, height)
        monitor.write("Error source check!")
    end
    local second_source_status, _ = http.checkURL(source_main)
    if second_source_status == false then
        monitor.setCursorPos(1, height)
        monitor.write("Error second source check!")
    end
    monitor.write("Second source check ... "..tostring(second_source_status))
    local third_source_status, _ = http.checkURL(source_version)
    if third_source_status == false then
        monitor.setCursorPos(1, height)
        monitor.write("Error third source check!")
    end
    monitor.setCursorPos(1, height)
    monitor.write("Third source check ... "..tostring(third_source_status))
    sleep(1)
    local httpResponce_version = http.get(source_version)
    local allText_version = httpResponce_version.readAll()
    local source_v = tonumber(string.sub(allText_version, string.len("version =  ")))
    monitor.setCursorPos(1, height)
    monitor.write("Source version "..source_v)
    local version = tonumber(string.sub(fs.open("version.lua","r").readAll(), string.len("version =  ")))
    monitor.setCursorPos(1, height)
    monitor.write("Version "..version)
    local version_check_status = "Error"
    if version < source_v then
        version_check_status = "Outdated version"
        load_autoupdate_files()
    elseif version >= source_v then
        version_check_status = "Latest version"
    end
    monitor.setCursorPos(1, height)
    monitor.write("Version check ... "..version_check_status)
end

function load_autoupdate_files()
    monitor.setTextColor(message_text_color)
    local file_startup = "startup.lua"
    local fs_startup = fs.open(file_startup, "w")
    local httpResponce_startup = http.get(source_startup)
    local allText_startup = httpResponce_startup.readAll()
    fs_startup.write(allText_startup)
    fs_startup.close()
    monitor.setCursorPos(1, height)
    monitor.write("Startup downloaded!")
    httpResponce_startup.close()

    local file_main = "main.lua"
    local fs_main = fs.open(file_main, "w")
    local httpResponce_main = http.get(source_main)
    local allText_main = httpResponce_main.readAll()
    fs_main.write(allText_main)
    fs_main.close()
    monitor.setCursorPos(1, height)
    monitor.write("Main downloaded!")
    httpResponce_main.close()

    local file_version = "version.lua"
    local fs_version = fs.open(file_version, "w")
    local httpResponce_version = http.get(source_version)
    local allText_version = httpResponce_version.readAll()
    fs_version.write(allText_version)
    fs_version.close()
    monitor.setCursorPos(1, height)
    monitor.write("Version downloaded!")
    httpResponce_version.close()
    monitor.setCursorPos(1, height)
    monitor.write("New version downloaded!")
    sleep(0.5)
    monitor.setCursorPos(1, height)
    monitor.write("Rebooting to apply changes...")
    sleep(1)
    os.reboot()
end

monitor.setTextColor(text_color)
monitor.setBackgroundColor(bg_color)
monitor.clear()
local space_title_v = math.floor((height / 2))
local space_title_h = math.ceil((width - string.len(title)) / 2)
monitor.setCursorPos(space_title_h, space_title_v)
monitor.write(title)
local subtitle = subtitle_list[math.random(subtitle_list_count)]
local space_subtitle_v = math.floor((height / 2))
local space_subtitle_h = math.ceil((width - string.len(subtitle)) / 2)
monitor.setCursorPos(space_subtitle_h, space_subtitle_v + 1)
monitor.setTextColor(second_text_color)
monitor.write(subtitle)
autoupdate()
sleep(2)
shell.run("main")