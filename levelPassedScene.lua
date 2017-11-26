----------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()

local ragdogLib = require "ragdogLib";
local networksLib = require "networksLib";

local ads = require( "ads" )
local myData= require "myData";
--For the second parameter, options must be a Lua table containing information to pre-populate the form, for example:
local options = {
    
    message = "Check out this photo!",
    listener = eventListener,
    
}
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
local currentScore,bestScore;
-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )
    
    ads.show( "banner", { x=0, y=-45, appId=myData.bannerAppID } )
    local group = self.view;
    
    local bg = display.newImageRect(group, "IMG/SUCCEED-01.png", totalWidth+80, totalHeight);
    bg.x, bg.y = centerX, centerY;
    
    --  local box = display.newImageRect(group, "IMG/go.png", 233, 208);
    --  box.x, box.y = centerX, centerY-100;
    
    
    local params = event.params;
    
    
    if params.level == "level1Scene" then
        
        currentScore=myData.lv1_score;
        bestScore=myData.getLv1beset(myData.lv1_score);
        
    elseif params.level == "level2Scene" then
        
        currentScore=myData.lv2_score;
        bestScore=myData.getLv2beset(myData.lv2_score);
        
    end
    
    
    --    if bestScore < _G.currentScore then
    --        bestScore = _G.currentScore;
    --        ragdogLib.setSaveValue("bestScore", bestScore, true);
    --      --  networksLib.addScoreToLeaderboard(bestScore);
    --    end
    
    local scoreText = display.newText(group, "Your score: " .. currentScore.." :)", 0, 0, native.systemFont, 30);
    scoreText.x, scoreText.y = bg.x, bg.y+30;
    
    local bestScoreText = display.newText(group,"The best score: "..bestScore.." !!!", 0, 0, native.systemFont, 30);
    bestScoreText.x, bestScoreText.y = bg.x, bg.y+75;
    
    local gamesuccesSFX = audio.loadSound("SFX/Succes.mp3");
    audio.play(gamesuccesSFX, {channel = audio.findFreeChannel()});
    local backButton = ragdogLib.newSimpleButton(group, myData.backButton, 240, 70);
    
    local nextButton = ragdogLib.newSimpleButton(group, "IMG/NEXT-01.png", 240, 70);
    nextButton.x, nextButton.y = centerX, centerY+140;
    function nextButton:touchBegan()
        self:setFillColor(.7, .7, .7);
        self.xScale, self.yScale = .9, .9;
        audio.play(_G.buttonSFX, {channel = audio.findFreeChannel()});
        
    end
    function nextButton:touchEnded()
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
        composer.gotoScene(params.unlock, "fade");
        --adsLib.showAd("during_game");
    end
    
    backButton.x, backButton.y = centerX, centerY+220;
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
    
    
    if params.level == "level1Scene" then
        ragdogLib.setSaveValue("level2State", true, true);
        
    elseif params.level == "level2Scene" then
        ragdogLib.setSaveValue("level3State", "unlocked", true);
        
    end
    
    --  local shareButton = ragdogLib.newSimpleButton(group, "IMG/share.png", 67, 67);
    --  shareButton.x, shareButton.y = centerX, centerY+120;
    --  function shareButton:touchBegan()
    --    self:setFillColor(.7, .7, .7);
    --    self.xScale, self.yScale = .9, .9;
    --    audio.play(_G.buttonSFX, {channel = audio.findFreeChannel()});
    --  end
    --  function shareButton:touchEnded()
    --    self:setFillColor(1, 1, 1);
    --    self.xScale, self.yScale = 1, 1;
    --    group:insert(shareLib.init(_G.socialShareMessage, {["totalPoints"] = (_G.currentScore or 0).."pts"}));
    --  end
    
    
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

