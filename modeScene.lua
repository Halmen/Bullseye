local composer = require( "composer" )

local scene = composer.newScene()

local ragdogLib = require "ragdogLib";
local networksLib = require "networksLib";
local adsLib = require "adsLib"
local myData= require "myData";
local ads = require( "ads" )


local totalWidth = _G.totalWidth;
local totalHeight = _G.totalHeight;
local leftSide = _G.leftSide;
local rightSide = _G.rightSide;
local topSide = _G.topSide;
local bottomSide = _G.bottomSide;
local centerX = display.contentCenterX;
local centerY = display.contentCenterY;







function scene:create( event )
    
    
    
    
    --ads.init( myData.adProvider, myData.appID, myData.adListener(event) )
    --ads.hide() 
    --ads.show( "banner", { x=0, y=-40, appId=myData.bannerAppID } )
    
    
    
    
    local unlocked=ragdogLib.getSaveValue("level2State") or false;
    
    adsLib.showAd("main_menu");
    local group = self.view;
    
    local bg = display.newImageRect(group, "IMG/MENU2@2x-01.png", totalWidth, totalHeight);
    bg.x, bg.y = centerX, centerY;
    
    local mode2=nil;
    local mode3=nil;
    local mode1 = ragdogLib.newSimpleButton(group, "IMG/MODE1@2x-01.png", 230, 60);
    mode1.x, mode1.y = centerX, centerY-160;
    function mode1:touchBegan()
        self:setFillColor(.7, .7, .7);
        self.xScale, self.yScale = .9, .9;
        audio.play(myData.buttonSFX, {channel = audio.findFreeChannel()});
    end
    function mode1:touchEnded()
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
        composer.gotoScene("level1Scene", "fade");
    end
    
    
    if unlocked then
        mode2 = ragdogLib.newSimpleButton(group, "IMG/MODE2UNLOCK@4x-01.png", 230, 60);
        mode2.x, mode2.y = centerX, centerY-50;
        function mode2:touchBegan()
            self:setFillColor(.7, .7, .7);
            self.xScale, self.yScale = .9, .9;
            audio.play(myData.buttonSFX, {channel = audio.findFreeChannel()});
            
        end
        function mode2:touchEnded()
            self:setFillColor(1, 1, 1);
            self.xScale, self.yScale = 1, 1;
            composer.gotoScene("level2Scene", "fade");
        end
    else
        mode2 = ragdogLib.newSimpleButton(group, "IMG/MODE2@2x-01.png", 230, 60);
        mode2.x, mode2.y = centerX, centerY-50;
        function mode2:touchBegan()
            self:setFillColor(.7, .7, .7);
            self.xScale, self.yScale = .9, .9;
            audio.play(_G.buttonSFX, {channel = audio.findFreeChannel()});
        end
        function mode2:touchEnded()
            self:setFillColor(1, 1, 1);
            self.xScale, self.yScale = 1, 1;
            
        end
        
        
    end
    
    
    
    
    local mode3 = ragdogLib.newSimpleButton(group, "IMG/MODE3@2x-01.png", 230, 60);
    mode3.x, mode3.y = centerX, centerY+60;
    function mode3:touchBegan()
        self:setFillColor(.7, .7, .7);
        self.xScale, self.yScale = .9, .9;
        audio.play(_G.buttonSFX, {channel = audio.findFreeChannel()});
    end
    function mode3:touchEnded()
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
    end
    
    local backButton = ragdogLib.newSimpleButton(group, myData.backButton, 230, 60);
    backButton.x, backButton.y = centerX, centerY+200;
    function backButton:touchBegan()
        self:setFillColor(.7, .7, .7);
        self.xScale, self.yScale = .9, .9;
        audio.play(_G.buttonSFX, {channel = audio.findFreeChannel()});
        
    end
    function backButton:touchEnded()
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
        composer.gotoScene("menuScene", "fade");
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

