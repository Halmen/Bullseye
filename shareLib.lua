local ragdogLib = require "ragdogLib";


local shareLib = {};

local totalWidth = _G.totalWidth;
local totalHeight = totalHeight;






shareLib.shareMessage = function(shareType, message)
    
    local serviceName = shareType
    local isAvailable = native.canShowPopup( "social", serviceName )
    local link="https://play.google.com/store/apps/details?id=com.yahoo.vericorpus.code"; 
    
    if shareType == "sms" then
        
        local options =
        {
            body = message.." "..link
        }
        native.showPopup("sms", options)
        
    elseif isAvailable then
        local listener = {}
        function listener:popup( event )
            print( "name(" .. event.name .. ") type(" .. event.type .. ") action(" .. tostring(event.action) .. ") limitReached(" .. tostring(event.limitReached) .. ")" )			
        end
        
        -- Show the popup
        native.showPopup( "social",
        {
            service = serviceName, -- The service key is ignored on Android.
            message = message,
            listener = listener,
            url = 
            { 
                link,
            }
        })
    else
        native.showAlert(
        "Cannot send " .. serviceName .. " message.",
        "Please setup your " .. serviceName .. " account or check your network connection.",
        { "OK" } )
    end
end

shareLib.init = function(message)
    local group = display.newGroup();
    local touchBlocker = display.newRect(group, display.contentCenterX, display.contentCenterY, totalWidth, totalHeight);
    touchBlocker:setFillColor(0, 0, 0, .5);
    function touchBlocker:touch(event)
        return true;
    end
    touchBlocker:addEventListener("touch", touchBlocker);
    
    local buttonHolder = display.newGroup();
    group:insert(buttonHolder);
    
    local bg = display.newImageRect(buttonHolder, "IMG/shareIMG/sharepop.png", 156, 142);
    
    
    buttonHolder.x, buttonHolder.y = touchBlocker.x, touchBlocker.y-50;
    
    local backButton = ragdogLib.newSimpleButton(buttonHolder, "IMG/back.png", 67, 67);
    backButton.x, backButton.y = bg.x, bg.y+130;
    function backButton:touchBegan()
        self:setFillColor(.5, .5, .5);
        self.xScale, self.yScale = .9, .9;
    end
    function backButton:touchEnded()
        audio.play(_G.buttonSFX, {channel = audio.findFreeChannel()});
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
        touchBlocker:removeEventListener("touch", touchBlocker);
        
        self:removeEventListener("touch", self);
        transition.to(group, {time = 200, alpha = 0, onComplete = group.removeSelf});
    end
    
    transition.from(touchBlocker, {time = 200, alpha = 0});
    transition.from(buttonHolder, {time = 200, xScale = 0.01, yScale = 0.01});
    return group;
end

return shareLib;