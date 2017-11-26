----------------------------------------------------------------------------------
local composer = require( "composer" )

local scene = composer.newScene()

local ragdogLib = require "ragdogLib";
local networksLib = require "networksLib";
local adsLib = require "adsLib";
local myData = require "myData";
local ads = require( "ads" )
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
local circleSpeed,currentScore,backButton;
local minAngleToMakePoint = 320;
local maxAngleToMakePoint = 30;


local pointsForHittingRed = 2;

local gameOverSFX, scorePointSFX, shootSFX , backgroundMusic, backgroundMusicChannel ;



-- "scene:create()"
function scene:create( event )
    
    ads.hide() 
    backgroundMusic = myData.Lv1BgMusic;
    audio.setVolume( 0.50, { channel = 2 } ) 
    backgroundMusicChannel = audio.play( backgroundMusic, { channel=2, loops=-1}); 
    
    local options =
    {
        effect = "fade",
        time = 400,
        params =
        {
            level = "level1Scene",
            unlock = "level2Scene"
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
    local infinity=ragdogLib.getSaveValue("infinity1") or false;
    local not_firstry= ragdogLib.getSaveValue("not_firstry1") or false;
    local not_infinity_firstry= ragdogLib.getSaveValue("not_infinity_firstry1") or false;
    gameOverSFX = audio.loadSound("SFX/laser explosion.mp3");
    scorePointSFX = audio.loadSound("SFX/scorePointSFX.mp3");
    shootSFX = audio.loadSound("SFX/laser shoot.mp3");
    
    
    local group = self.view;
    
    local bg = display.newImageRect(group, "IMG/BG-01.png", totalWidth, totalHeight);
    bg.x, bg.y = centerX, centerY;
    
    
    
    
    
    
    
    
    
    local circle = display.newImageRect(group, "IMG/circle.png", 164*circleScale, 164*circleScale);
    circle.x, circle.y = centerX, centerY-140;
    function circle:enterFrame()
        self.rotation = self.rotation+circleSpeed;
        if self.rotation > 360 then
            self.rotation = self.rotation-360;
        end
    end
    Runtime:addEventListener("enterFrame", circle);
    
    
    circle:toFront();
    
    
    if not not_firstry and not infinity then   
        
        local touchBlocker = display.newRect(group, display.contentCenterX, display.contentCenterY, totalWidth, totalHeight);
        touchBlocker:setFillColor(0, 0, 0, .5);
        function touchBlocker:touch(event)
            return true;
        end
        touchBlocker:addEventListener("touch", touchBlocker);
        
        local popup=ragdogLib.newSimpleButton(group, "IMG/popup screen@2x.png", 240, 160);
        popup.x, popup.y = centerX, centerY+100;
        
        local message = display.newText(group, "Hit the target 13 times to pass", 0, 0, native.systemFont, 14);
        message.x, message.y = centerX, centerY+100;  
        
        function popup:touchBegan()
            self:setFillColor(.5, .5, .5);
            self.xScale, self.yScale = .9, .9;
        end
        function popup:touchEnded()
            audio.play(_G.buttonSFX, {channel = audio.findFreeChannel()});
            self:setFillColor(1, 1, 1);
            self.xScale, self.yScale = 1, 1;
            touchBlocker:removeEventListener("touch", touchBlocker);   
            self:removeEventListener("touch", self);
            touchBlocker:removeSelf();
            self:removeSelf();
            message:removeSelf()
            
        end
        popup=nil;
        ragdogLib.setSaveValue("not_firstry1", true, true);
    end
    
    local laserguneffect = display.newImageRect(group, "IMG/LASERGUNEFFECT@2x-01.png", 200, 140);
    laserguneffect.x, laserguneffect.y = centerX, centerY+215;
    laserguneffect.isVisible=false;
    
    local lasergun = display.newImageRect(group, "IMG/LASERGUN@2x-01.png", 200, 140);
    lasergun.x, lasergun.y = centerX, centerY+215;
    
    local arrow = display.newImageRect(group, "IMG/LASERBEAM-01.png", 10, 31);
    arrow.x, arrow.y = centerX, lasergun.y-lasergun.contentHeight*.5-arrow.contentHeight*.5+15;
    arrow.xStart, arrow.yStart = arrow.x, arrow.y;
    arrow.state = 0;
    arrow.isVisible = false;
    
    
    local widget = require( "widget" );
    
    local function handleButtonEvent( event )
        
        if ( "ended" == event.phase ) then
            composer.gotoScene("menuScene", options)
            
        end
    end;
    
    backButton = widget.newButton(
    {
        label = "←",
        onEvent = handleButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 40,
        height = 40,
        cornerRadius = 2,
        
        strokeColor = { default={0,0,0,0}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }
    );
    
    backButton.x, backButton.y = centerX-140, centerY-263;
    
    if infinity then
        
        if not not_infinity_firstry then
            
            local touchBlocker = display.newRect(group, display.contentCenterX, display.contentCenterY, totalWidth, totalHeight);
            touchBlocker:setFillColor(0, 0, 0, .5);
            function touchBlocker:touch(event)
                return true;
            end
            touchBlocker:addEventListener("touch", touchBlocker);
            
            local popup=ragdogLib.newSimpleButton(group, "IMG/popup screen@2x.png", 240, 160);
            popup.x, popup.y = centerX, centerY+100;
            
            local message = display.newText(group, "Crazy mode unlocked!\nGet the highest highscore ;) ", 0, 0, native.systemFont, 14);
            message.x, message.y = centerX, centerY+100;  
            
            function popup:touchBegan()
                self:setFillColor(.5, .5, .5);
                self.xScale, self.yScale = .9, .9;
            end
            function popup:touchEnded()
                audio.play(_G.buttonSFX, {channel = audio.findFreeChannel()});
                self:setFillColor(1, 1, 1);
                self.xScale, self.yScale = 1, 1;
                touchBlocker:removeEventListener("touch", touchBlocker);   
                self:removeEventListener("touch", self);
                touchBlocker:removeSelf();
                self:removeSelf();
                message:removeSelf()
                
            end
            
            popup=nil;
            ragdogLib.setSaveValue("not_infinity_firstry1", true, true);
            
        end
        
        local mode = display.newText(group, "∞", 0, 0, native.systemFont, 50);
        mode.x, mode.y = centerX-100, centerY-260;
        
        
        
        
    end
    
    --    timer.pause();
    
    
    function arrow:enterFrame()
        
        if self.state == 1 then
            if self.y-self.contentHeight*.5 <= circle.y+circle.height*.5 then
                self.isVisible = false;
                lasergun.isVisible=true;
                laserguneffect.isVisible=false;
                
                if circle.rotation >= minAngleToMakePoint or circle.rotation <= maxAngleToMakePoint then
                    print("rotation" , circle.rotation)
                    
                    if circleSpeed == 0 then
                        circleSpeed = circleInitialSpeed;
                    else
                        circleSpeed = circleSpeed+speedIncreaseAtEveryPoint;
                        if circleSpeed > maxCircleSpeed then
                            circleSpeed = maxCircleSpeed;
                        end
                    end
                    currentScore = currentScore+2;
                    --                    if circle.rotation >= minRedAngleToMakePoint or circle.rotation <= maxRedAngleToMakePoint then
                    --                        print("rotation" , circle.rotation)
                    --                        print("min" , minRedAngleToMakePoint)
                    --                        print("max" , maxRedAngleToMakePoint)
                    --                        currentScore = currentScore+pointsForHittingRed;
                    --                        audio.play(hittingRedSFX, {channel = audio.findFreeChannel()});
                    --                    else
                    audio.play(scorePointSFX, {channel = audio.findFreeChannel()});
                    --                    end
                    transition.to(circle, {time = 100, xScale = 1.1, yScale = 1.1});
                    transition.to(circle, {delay = 100, time = 50, xScale = 1, yScale = 1});
                    self.state = 0;
                    self.x, self.y = arrow.xStart, arrow.yStart;
                else
                    self.isVisible = false;
                    self.state = 2;
                    self.time = 0;
                    audio.play(gameOverSFX, {channel = audio.findFreeChannel(), duration = 30000,});
                    for i = 1, 20 do
                        local particle = display.newRect(group, 0, 0, 5, 5);
                        particle.xSpeed = math.random(-30, 30)*.1;
                        particle.ySpeed = math.random(20, 40)*.1;
                        particle.x, particle.y = self.x, self.y-self.contentHeight*.5;
                        function particle:enterFrame()
                            self.x, self.y = self.x+self.xSpeed, self.y+self.ySpeed;
                            self.alpha = self.alpha-0.01;
                            if self.alpha <= 0 then
                                Runtime:removeEventListener("enterFrame", self);
                                self:removeSelf();
                            end
                        end
                        Runtime:addEventListener("enterFrame", particle);
                        circleSpeed = 0;
                    end
                end
                
                if not infinity then
                    if currentScore == 26 then
                        myData.lv1_score = currentScore;
                        ragdogLib.setSaveValue("infinity1", true, true);
                        composer.gotoScene("levelPassedScene", options);
                        
                    end
                end
            end
            
            self.y = self.y-arrowSpeed;
        elseif self.state == 2 then
            
            self.time = self.time+1;   
            if self.time >= 90 then
                Runtime:removeEventListener("enterFrame", self);
                myData.lv1_score = currentScore;
                myData.death=myData.death+1;
                if myData.death%5 == 0 then
                    ads.show( "interstitial", { appId=myData.interstitialAppID } )
                    myData.death=0;
                end
                composer.gotoScene("gameOverScene", options);
            end
        end
    end
    Runtime:addEventListener("enterFrame", arrow);
    
    
    
    local tapToStart = display.newText(group, "Tap to Start", 0, 0, native.systemFont, 25);
    tapToStart.x, tapToStart.y = centerX, centerY;
    
    
    local function onComplete( event )
        
        local action = event.action
        if "clicked" == event.action then
            if 1 == event.index then
                
            end
        end    
    end
    
    
    
    function bg:touch(event)
        
        native.showPopup( "activity", options );
        arrow.isVisible = true;
        lasergun.isVisible=false;
        laserguneffect.isVisible=true;
        
        
        
        if event.phase == "began" then
            if arrow.state == 0 then
                arrow.state = 1;
                audio.play(shootSFX, {channel = audio.findFreeChannel(), duration = 400,});
                if tapToStart then
                    transition.to(tapToStart, {time = 200, alpha = 0, onComplete = tapToStart.removeSelf});
                    tapToStart = nil;
                end
            end
        end
    end
    bg:addEventListener("touch", bg);
    
    local scoreText = display.newText(group, currentScore, 0, 0, native.systemFont, 30);
    scoreText.x, scoreText.y = rightSide-10-scoreText.contentWidth*.5, topSide+10+scoreText.contentHeight*.5;
    
    function scoreText:enterFrame()
        self.text = currentScore;
        self.x, self.y = rightSide-10-self.contentWidth*.5, topSide+10+self.contentHeight*.5;
    end
    Runtime:addEventListener("enterFrame", scoreText);
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
        audio.dispose(gameOverSFX);
        gameOverSFX = nil;
        audio.dispose(scorePointSFX);
        scorePointSFX = nil;
        audio.dispose(shootSFX);
        shootSFX = nil;
        -- audio.dispose(backgroundMusic);
        backgroundMusic = nil;
        audio.dispose(backgroundMusicChannel);
        backgroundMusicChannel = nil;
        backButton:removeSelf();
        backButton=nil;
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