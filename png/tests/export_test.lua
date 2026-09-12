local root = app.params.root
local exporter = root .. "/png/Export selected frames as numbered PNG.lua"
local folder = app.params.testout
app.fs.makeAllDirectories(folder)
local realApp, realDialog = app, Dialog
local sprite = Sprite(3, 3, ColorMode.RGB)
local colors = {Color(255,0,0,255), Color(0,255,0,128), Color(0,0,255,255)}
for i=1,3 do
    if i>1 then sprite:newEmptyFrame() end
    local img = Image(1,1,ColorMode.RGB)
    img:clear(colors[i])
    sprite:newCel(sprite.layers[1], i, img, Point(1,1))
end
local hidden = sprite:newLayer()
hidden.isVisible = false
local img = Image(3,3,ColorMode.RGB)
img:clear(Color(255,255,255,255))
sprite:newCel(hidden,1,img)
realApp.activeFrame = sprite.frames[2]
local originalBytes = sprite.layers[1]:cel(1).image.bytes
local alerts = {}
local function run(name, ui, selection)
    app = setmetatable({isUIAvailable=ui, params={filename=folder.."/"..name..".png",frames=selection or "all"},
        alert=function(a) alerts[#alerts+1]=a end}, {__index=realApp})
    if ui then
        Dialog = function()
            local d = {data={}}
            for _,kind in ipairs{"file","label","button","check"} do
                d[kind]=function(self, p)
                    if kind=="file" then self.data[p.id]=folder.."/"..name..".png" end
                    if kind=="check" then self.data[p.id]=p.selected end
                    if p.onclick then self[p.id]=p.onclick end
                    return self
                end
            end
            function d:modify(p) self.data[p.id]=p.selected end
            function d:show()
                for i=1,3 do assert(self.data["frame_"..i]==true,"Default unchecked") end
                self.clearAll()
                for i=1,3 do assert(self.data["frame_"..i]==false) end
                self.selectAll()
                for i=1,3 do assert(self.data["frame_"..i]==true) end
                if selection=="none" then self.clearAll() else self.data.frame_2=false end
                self.data.ok=selection~="cancel"
            end
            return d
        end
    end
    dofile(exporter)
    app, Dialog = realApp, realDialog
    assert(realApp.activeSprite==sprite and realApp.activeFrame.frameNumber==2)
    assert(sprite.layers[1]:cel(1).image.bytes==originalBytes)
end
run("all",false)
run("selected",true)
run("selected",true)
run("none",true,"none")
run("cancel",true,"cancel")
run("invalid",false,"0")
for i=1,3 do
    local image=Image{fromFile=folder..string.format("/all_%03d.png",i)}
    assert(image.width==3 and image.height==3)
    assert(realApp.pixelColor.rgbaA(image:getPixel(0,0))==0)
    local p=image:getPixel(1,1)
    assert(realApp.pixelColor.rgbaR(p)==colors[i].red)
    assert(realApp.pixelColor.rgbaG(p)==colors[i].green)
    assert(realApp.pixelColor.rgbaB(p)==colors[i].blue)
    assert(realApp.pixelColor.rgbaA(p)==colors[i].alpha)
end
assert(not realApp.fs.isFile(folder.."/selected_002.png"))
for _,n in ipairs{1,3} do
    assert(realApp.fs.isFile(folder..string.format("/selected_%03d.png",n)))
    assert(realApp.fs.isFile(folder..string.format("/selected_%03d_2.png",n)))
end
for _,name in ipairs{"none","cancel","invalid"} do
    assert(not realApp.fs.isFile(folder.."/"..name.."_001.png"))
end
sprite:close()
print("PASS: checkbox defaults/toggles, selected frames, cancellation, invalid CLI, duplicate protection, RGBA pixels, bounds, hidden layers, source preservation")
