
local monitor = peripheral.find('monitor')
local speaker = peripheral.find("speaker")
local width, height = monitor.getSize()
local space = " "
local source = "https://github.com/LimonchikTM/LimonOS"
local source_version = "https://raw.githubusercontent.com/LimonchikTM/LimonOS/main/version.lua"
local text_color = colors.yellow
local second_text_color = colors.white
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
    local source_status, _ = http.checkURL(source)
    print("Source check ... "..tostring(source_status))
    if source_status == false then
        printError("Error source check!")
    end
    local second_source_status, _ = http.checkURL(source_version)
    if second_source_status == false then
        printError("Error second source check!")
    end
    print("Second source check ... "..tostring(second_source_status))
    sleep(1)
    local httpResponce_version = http.get(source_version)
    local allText_version = httpResponce_version.readAll()
    local source_v = tonumber(string.sub(allText_version, string.len("version =  ")))
    print("Source version "..source_v)
    local version = tonumber(string.sub(fs.open("version.lua","r").readAll(), string.len("version =  ")))
    print("Version "..version)
    local version_check_status = "Error"
    if version < source_v then
        version_check_status = "Outdated version"
    elseif version >= source_v then
        version_check_status = "Latest version"
    end
    print("Version check ... "..version_check_status)
    local httpResponce = http.get(source)
    local allText = httpResponce.readAll()
    httpResponce.close()
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
shell.run("rs_programm")