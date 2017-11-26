----------------------------------------------------------------------------------
local composer = require( "composer" )
local shareLib = require "shareLib";
local scene = composer.newScene()
local ragdogLib = require "ragdogLib";
local networksLib = require "networksLib";
local ads = require( "ads" )
local myData = require "myData";



-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

--let's localize these values for faster reading

local totalWidth = _G.totalWidth;
local totalHeight = _G.totalHeight;
local leftSide = _G.leftSide;
local rightSide = _G.rightSide;
local topSide = _G.topSide;
local bottomSide = _G.bottomSide;
local centerX = display.contentCenterX;
local centerY = display.contentCenterY;


local backgroundMusic,backgroundMusicChannel ;

-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )
    
    
    --ads.hide() 
    
    
    local group = self.view;
    local send="Hellooo";
    local replaceData={["totalPoints"] = (25).."pts"};
    
    local bg = display.newImageRect(group, "IMG/bg@2x.png", totalWidth+100, totalHeight);
    bg.x, bg.y = centerX, centerY;
    
    backgroundMusic =myData.mainMenuBgMusic;
    audio.setVolume( 0.50, { channel = 1 } ) 
    backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1}) ; 
    
    
    local playButton = ragdogLib.newSimpleButton(group, "IMG/play.png", 70, 70);
    playButton.x, playButton.y = centerX+10, centerY-10;
    
    transition.to(playButton, {time = 600,iterations=-1, xScale = 2, yScale = 2});
    transition.to(playButton, {delay = 100, time = 600, iterations=-1, xScale = 1, yScale = 1});
    
    function playButton:touchBegan()
        self:setFillColor(.7, .7, .7);
        self.xScale, self.yScale = .9, .9;
        audio.play(myData.buttonSFX, {channel = audio.findFreeChannel()});
    end
    function playButton:touchEnded()
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
        composer.gotoScene("modeScene", "fade");
    end
    
    
    
    
    local rateButton = ragdogLib.newSimpleButton(group, "IMG/rate.png", 90, 67);
    rateButton.x, rateButton.y = centerX-100, centerY+210;
    function rateButton:touchBegan()
        self:setFillColor(.7, .7, .7);
        self.xScale, self.yScale = .9, .9;
        audio.play(myData.buttonSFX, {channel = audio.findFreeChannel()});
    end
    function rateButton:touchEnded()
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
        system.openURL( 'https://play.google.com/store/apps/details?id=com.yahoo.vericorpus.code')
        --        local options =
        --        {
        --            iOSAppId = _G.iOSappIDforRate, --your ios app id
        --            supportedAndroidStores = {"google", "samsung", "amazon", "nook"}, --the store you support on android
        --        }
        --        native.showPopup("appStore", options);
    end
    
    local twitter = ragdogLib.newSimpleButton(group, "IMG/shareIMG/twit.png", 47, 47);
    twitter.x, twitter.y = centerX, centerY+210;
    function twitter:touchBegan()
        self:setFillColor(.7, .7, .7);
        self.xScale, self.yScale = .9, .9;
        audio.play(myData.buttonSFX, {channel = audio.findFreeChannel()});
    end
    function twitter:touchEnded()
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
        shareLib.shareMessage("twitter", send);
    end
    
    
    local facebook = ragdogLib.newSimpleButton(group, "IMG/shareIMG/fb.png", 47, 47);
    facebook.x, facebook.y = centerX+60, centerY+210;
    function facebook:touchBegan()
        self:setFillColor(.7, .7, .7);
        self.xScale, self.yScale = .9, .9;
        audio.play(myData.buttonSFX, {channel = audio.findFreeChannel()});
    end
    function facebook:touchEnded()
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
        shareLib.shareMessage("facebook", send);
        
    end
    
    
    local message = ragdogLib.newSimpleButton(group, "IMG/shareIMG/sms.png", 47, 47);
    message.x, message.y = centerX+120, centerY+210;
    function message:touchBegan()
        self:setFillColor(.7, .7, .7);
        self.xScale, self.yScale = .9, .9;
        audio.play(myData.buttonSFX, {channel = audio.findFreeChannel()});
    end
    function message:touchEnded()
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
        shareLib.shareMessage("sms", send);
    end    
    
    
    local soundButton = ragdogLib.newComplexButton(group, "IMG/soundon.png", 57, 57, "IMG/sounoff.png", 57, 57);
    soundButton.x, soundButton.y = centerX+120, centerY-120;
    if audio.getVolume() < 1 then
        soundButton[1].isVisible = false;
        soundButton[2].isVisible = true;
    end
    function soundButton:touchBegan()
        if self[1].isVisible then
            self[1]:setFillColor(.7, .7, .7);
            self[1].xScale, self[1].yScale = .9, .9;
        elseif self[2].isVisible then
            self[2]:setFillColor(.7, .7, .7);
            self[2].xScale, self[1].yScale = .9, .9;
        end
        audio.play(myData.buttonSFX, {channel = audio.findFreeChannel()});
    end
    function soundButton:touchEnded()
        if self[1].isVisible then
            self[1]:setFillColor(1, 1, 1);
            self[1].xScale, self[1].yScale = 1, 1;
            self[1].isVisible = false;
            self[2].isVisible = true;
            audio.setVolume(0);
        elseif self[2].isVisible then
            self[2]:setFillColor(1, 1, 1);
            self[2].xScale, self[1].yScale = 1, 1;
            self[2].isVisible = false;
            self[1].isVisible = true;
            audio.setVolume(1);
        end
    end
    
    
end


-- "scene:show()"
function scene:show( event )
    
    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )
    
    local sceneGroup = self.view
    local phase = event.phase
    
    
    
    
    if ( phase == "will" ) then
        
        audio.stop();
        -- audio.dispose(backgroundMusic);
        backgroundMusic = nil;
        audio.dispose(backgroundMusicChannel);
        backgroundMusicChannel = nil;
        local removeAll;
        removeAll = function(group)
            if group.enterFrame then
                Runtime:removeEventListener("enterFrame", group);
            end
            if group.touch then
                group:removeEventListener("touch", group);
                Runtime:removeEventListener("touch", group);
            end		
            for i = group.numChildren, 1, -1 do
                if group[i].numChildren then
                    removeAll(group[i]);
                else
                    if group[i].enterFrame then
                        Runtime:removeEventListener("enterFrame", group[i]);
                    end
                    if group[i].touch then
                        group[i]:removeEventListener("touch", group[i]);
                        Runtime:removeEventListener("touch", group[i]);
                    end
                end
            end
        end
        
        removeAll(self.view);
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )
    
    local sceneGroup = self.view
    
    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene