----------------------------------------------------------------------------------
local composer = require( "composer" )

local scene = composer.newScene()

local ragdogLib = require "ragdogLib";
local networksLib = require "networksLib";
local adsLib = require "adsLib";
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

local buttonSFX = _G.buttonSFX;

-- -------------------------------------------------------------------------------
local circleScale = .8;
local arrowSpeed = 10;
local circleInitialSpeed = 1;
local speedIncreaseAtEveryPoint = .5;
local maxCircleSpeed = 20;
local circleSpeed;
local currentScore;

local minAngleToMakePoint = 340;
local maxAngleToMakePoint = 20;


local pointsForHittingRed = 2;

local gameOverSFX, scorePointSFX, shootSFX , backgroundMusic, backgroundMusicChannel ;





-- "scene:create()"
function scene:create( event )
    
 
    local options =
    {
        effect = "fade",
        time = 400,
        params =
        {
            level = "level3Scene"
        }
    }
    
    
    --    
    --    
    --    local function cancelMyAlert()
    --        native.cancelAlert( alert )
    --    end
    --    
    --    timer.performWithDelay( 10000, cancelMyAlert )
    
    adsLib.showAd("main_menu");
    circleSpeed = 0;
    currentScore = 0;
    

    
    local group = self.view;
    
    local bg = display.newImageRect(group, "Default.png", totalWidth, totalHeight);
    bg.x, bg.y = centerX, centerY;
    
    local bg = display.newImageRect(group, "IMG/CS.png", 250, 200);
    bg.x, bg.y = centerX, centerY-50;

   local backButton = ragdogLib.newSimpleButton(group, myData.backButton, 240, 70);
    backButton.x, backButton.y = centerX, centerY+190;
    
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

    
--    local function onComplete( event )
--        
--        local action = event.action
--        if "clicked" == event.action then
--            if 1 == event.index then
--                
--            end
--        end    
--    end
--    
--    local alert = native.showAlert( "Instructions:", "Hit the target 10 times to pass!", { "OK" }, onComplete )    
    

    
    
  
 
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

