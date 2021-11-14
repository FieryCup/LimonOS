
local monitor = peripheral.find('monitor')
local speaker = peripheral.find("speaker")
monitor.setTextScale(1)
local width, height = monitor.getSize()
local space = " "
local source = "https://raw.githubusercontent.com/LimonchikTM/LimonOS/main/"
local file_startup = "startup.lua"
local file_main = "main.lua"
local file_version = "version.lua"
local text_color = colors.yellow
local second_text_color = colors.white
local message_text_color = colors.gray

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

local subtitle_lenght = 1
for i, k in ipairs(subtitle_list) do
    if subtitle_lenght < k then
        subtitle_lenght = k
    end
end
setScale(subtitle_lenght)
function setScale(string_length)
    for i = 5, 0.5, -0.5 do
        monitor.setTextScale(i)
        if string_length <= monitor.getSize() then
            break
        end
    end
end

local bg_color = colors.black
local title = "LimonOS"
local width, height = monitor.getSize()

function checkURLFile(file)
    local status, _ = http.checkURL(source..file)
    monitor.setCursorPos(1, height)
    monitor.write("Checking access to the source of file "..file.." ... "..tostring(status)..string.rep(space, width))
    if status == false then
        monitor.setCursorPos(1, height)
        monitor.write("Error checking access to source of file "..file.." !"..string.rep(space, width))
        printError("Error checking access to source of file "..file.." !"..string.rep(space, width))
        exit()
    end
end

function autoupdate()
    monitor.setTextColor(message_text_color)
    checkURLFile(file_startup)
    checkURLFile(file_main)
    checkURLFile(file_version)
    sleep(1)
    local httpResponce_version = http.get(source..file_version)
    local allText_version = httpResponce_version.readAll()
    local source_v = tonumber(string.sub(allText_version, string.len("version =  ")))
    monitor.setCursorPos(1, height)
    monitor.write("Source version "..source_v..string.rep(space, width))
    local version = tonumber(string.sub(fs.open("version.lua","r").readAll(), string.len("version =  ")))
    monitor.setCursorPos(1, height)
    monitor.write("Version "..version..string.rep(space, width))
    local version_check_status = "Error"
    if version < source_v then
        version_check_status = "Outdated version"
        load_autoupdate_files()
    elseif version >= source_v then
        version_check_status = "Latest version"
    end
    monitor.setCursorPos(1, height)
    monitor.write("Version check ... "..version_check_status..string.rep(space, width))
end

function downloadFile(file)
    local fs_file = fs.open(file, "w")
    local httpResponce = http.get(source..file)
    if httpResponce then
        local allText = httpResponce.readAll()
        fs_file.write(allText)
        fs_file.close()
        monitor.setCursorPos(1, height)
        monitor.write(file.." downloaded!"..string.rep(space, width))
        httpResponce.close()
    else
        monitor.setCursorPos(1, height)
        monitor.write("Unable to download the file "..file..string.rep(space, width))
        print("Unable to download the file "..file)
        print("Make sure you have the HTTP API enabled or")
        print("an internet connection!")
        exit()
    end
end

function load_autoupdate_files()
    monitor.setTextColor(message_text_color)
    downloadFile(file_startup)
    downloadFile(file_main)
    downloadFile(file_version)
    monitor.setCursorPos(1, height)
    monitor.write("New version downloaded!"..string.rep(space, width))
    sleep(0.5)
    monitor.setCursorPos(1, height)
    monitor.write("Rebooting to apply changes..."..string.rep(space, width))
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