-- Selected numbered PNG exporter, based on the checkbox workflow in this fork.
-- Original PSD workflow Copyright (c) 2020 Tsukina-7mochi
-- Modifications Copyright (c) 2026 Lichiphen
-- SPDX-License-Identifier: MIT (see ../LICENSE)
-- Standalone script; no bundler or external libraries required.

local function report(title, message)
    if app.isUIAvailable then
        app.alert{title=title, text=message, buttons="OK"}
    else
        print(title .. ": " .. message)
    end
end

local sprite = app.activeSprite
if not sprite then
    report("Export Failed", "No sprite selected.")
    return
end

local function getDefaultFilename ()
    local filename = app.fs.filePathAndTitle(sprite.filename)
    if filename == nil or filename == "" then
        filename = "sprite"
    end
    return filename .. ".png"
end

local function getOptionsFromDialog ()
    local dialog = Dialog({ title = "Export selected frames as PNG" })
    dialog
        :file({
            id = "filename",
            label = "Base filename",
            title = "Choose base filename...",
            save = true,
            filename = getDefaultFilename(),
            filetypes = { "png" },
        })
        :label({
            label = "Naming",
            text = "base_001.png / duplicate: base_001_2.png",
        })
        :button({
            id = "selectAll",
            label = "Frames",
            text = "Select All",
            onclick = function ()
                for i = 1, #sprite.frames do
                    dialog:modify({ id = "frame_" .. tostring(i), selected = true })
                end
            end,
        })
        :button({
            id = "clearAll",
            text = "Clear All",
            newrow = false,
            onclick = function ()
                for i = 1, #sprite.frames do
                    dialog:modify({ id = "frame_" .. tostring(i), selected = false })
                end
            end,
        })

    for i = 1, #sprite.frames do
        dialog:check({
            id = "frame_" .. tostring(i),
            label = "",
            text = string.format("%03d", i),
            selected = true,
            newrow = ((i - 1) % 6 == 0),
        })
    end

    dialog
        :check({
            id = "showCompleated",
            label = "",
            text = "Show dialog when succeeded",
            selected = true,
        })
        :button({
            id = "ok",
            text = "&Export",
            focus = true,
        })
        :button({
            id = "cancel",
            text = "&Cancel",
        })
        :label({
            text = tostring(#sprite.frames) .. " frame(s) / version " .. "1.0.0",
        })
    dialog:show()

    local filename = dialog.data.filename --[[ @as string ]]
    local showCompleated = dialog.data.showCompleated --[[ @as boolean ]]
    local proceed = dialog.data.ok --[[ @as boolean ]]
    local frameIndexes = {}

    if proceed then
        for i = 1, #sprite.frames do
            if dialog.data["frame_" .. tostring(i)] then
                frameIndexes[#frameIndexes + 1] = i
            end
        end

        if #frameIndexes == 0 then
            app.alert({
                title = "Export Cancelled",
                text = "No frames are checked.",
                buttons = "OK",
            })
            proceed = false
        end
    end

    return filename, frameIndexes, showCompleated, proceed
end


local filename, frameIndexes, showCompleted, proceed
if app.isUIAvailable then
    filename, frameIndexes, showCompleted, proceed = getOptionsFromDialog()
else
    filename = app.params.filename or app.params.out
    frameIndexes = {}
    local requested = app.params.frames or app.params.frame or "all"
    if requested == "all" then
        for i = 1, #sprite.frames do frameIndexes[#frameIndexes + 1] = i end
    else
        local seen = {}
        for token in (requested .. ","):gmatch("(.-),") do
            local n = tonumber(token)
            if not n or n % 1 ~= 0 or n < 1 or n > #sprite.frames then
                report("Export Failed", "Invalid frame list: " .. requested)
                return
            end
            if not seen[n] then
                frameIndexes[#frameIndexes + 1] = n
                seen[n] = true
            end
        end
        table.sort(frameIndexes)
    end
    showCompleted, proceed = true, true
end
if not proceed then return end
if not filename or filename:match("^%s*$") then
    report("Export Failed", "Choose a base filename.")
    return
end
if #frameIndexes == 0 then
    report("Export Cancelled", "No frames are checked.")
    return
end

local base = filename:gsub("%.[Pp][Nn][Gg]$", "")
if app.fs.fileName(base) == "" then
    report("Export Failed", "Choose a base filename, not only a folder.")
    return
end
local digits = math.max(3, #tostring(#sprite.frames))
local completed = 0
for _, frameNumber in ipairs(frameIndexes) do
    local numbered = string.format("%s_%0" .. digits .. "d", base, frameNumber)
    local output = numbered .. ".png"
    local suffix = 2
    while app.fs.isFile(output) or app.fs.isDirectory(output) do
        output = numbered .. "_" .. suffix .. ".png"
        suffix = suffix + 1
    end
    local ok, err = pcall(function()
        -- Render into an independent RGBA image. The original sprite, active
        -- frame, selection, layers, and undo history are never changed.
        local image = Image(ImageSpec{
            width=sprite.width, height=sprite.height,
            colorMode=ColorMode.RGB, colorSpace=sprite.colorSpace
        })
        image:clear()
        image:drawSprite(sprite, frameNumber)
        local saved = image:saveAs(output)
        if saved == false or not app.fs.isFile(output) then
            error("Could not save " .. output)
        end
    end)
    if not ok then
        report("Export Failed", tostring(completed) .. " file(s) exported. Frame " ..
            frameNumber .. ": " .. tostring(err))
        return
    end
    completed = completed + 1
end
if showCompleted then
    report("Export Succeeded", completed .. " PNG file(s) exported to " .. app.fs.filePath(base))
end