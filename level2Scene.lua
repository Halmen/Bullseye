----------------------------------------------------------------------------------
local composer = require( "composer" )

local scene = composer.newScene()

local ragdogLib = require "ragdogLib";
local networksLib = require "networksLib";
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

-- -------------------------------------------------------------------------------
local barrelScale = .8;
local arrowSpeed = 10;
local barrelInitialSpeed = .5;
local speedIncreaseAtEveryPoint = .5;
local maxCircleSpeed = 20;
local barrelSpeed,currentScore, backButton;
local targetHit=0;


local t1min = 0;
local t1max = 8;
local t2min = 65;
local t2max = 75;
local t3min = 133;
local t3max = 143;
local t4min = 190;
local t4max = 217;
local t5min = 285;
local t5max = 295;
local pointsForHittingRed = 2;

local arrowhitSFX, shootSFX ,backgroundMusic, backgroundMusicChannel ;





-- "scene:create()"
function scene:create( event )
    
    ads.hide() 
    backgroundMusic = myData.Lv2BgMusic;
    audio.setVolume( 0.30, { channel = 3 } ) 
    backgroundMusicChannel = audio.play( backgroundMusic, { channel=3, loops=-1}); 
    --    
    local options =
    {
        effect = "fade",
        time = 400,
        params =
        {
            level = "level2Scene",
            unlock = "level3Scene"
        }
    }
    
    
    
    
    
    
    --    
    
    --    local function cancelMyAlert()
    --        native.cancelAlert( alert )
    --    end
    --    
    --    timer.performWithDelay( 10000, cancelMyAlert )
    
    
    barrelSpeed = 0;
    currentScore = 0;
    
    
    
    arrowhitSFX = audio.loadSound("SFX/Arrow hit.mp3");
    shootSFX = audio.loadSound("SFX/bowfire.mp3");
    
    local group = self.view;
    local gp = self.view;
    
    local infinity=ragdogLib.getSaveValue("infinity2") or false;
    local not_firstry= ragdogLib.getSaveValue("not_firstry2") or false;
    local not_infinity_firstry=ragdogLib.getSaveValue("not_infinity_firstry2") or false;
    
    local bg = display.newImageRect(group, "IMG/BG2-01.png", totalWidth, totalHeight);
    bg.x, bg.y = centerX, centerY;
    
    local barrel = display.newImageRect( group, "IMG/BARREL@4x-01.png", 164*barrelScale, 164*barrelScale);
    barrel.x, barrel.y = centerX, centerY-80;
    
    
    
    local barrel1 = display.newImageRect( group,"IMG/target1@4x.png", 190, 190);
    barrel1.x, barrel1.y = centerX, centerY-80;
    barrel1.isVisible=false;
    
    
    local barrel2 = display.newImageRect(group, "IMG/target2@4x.png", 190, 190);
    barrel2.x, barrel2.y = centerX, centerY-80;
    barrel2.isVisible=false;
    
    
    local barrel3 = display.newImageRect(group, "IMG/target3@4x.png", 190, 190);
    barrel3.x, barrel3.y = centerX, centerY-80;
    barrel3.isVisible=false;
    
    
    local barrel4 = display.newImageRect(group, "IMG/target4@4x.png", 190, 190);
    barrel4.x, barrel4.y = centerX, centerY-80;
    barrel4.isVisible=false;
    
    
    local barrel5 = display.newImageRect(group, "IMG/target5@4x.png", 190, 190);
    barrel5.x, barrel5.y = centerX, centerY-80;
    barrel5.isVisible=false;
    
    
    
    if not not_firstry and not infinity then   
        
        local touchBlocker = display.newRect(group, display.contentCenterX, display.contentCenterY, totalWidth, totalHeight);
        touchBlocker:setFillColor(0, 0, 0, .5);
        function touchBlocker:touch(event)
            return true;
        end
        touchBlocker:addEventListener("touch", touchBlocker);
        
        local popup=ragdogLib.newSimpleButton(group, "IMG/popup screen@2x.png", 240, 160);
        popup.x, popup.y = centerX, centerY+100;
        
        local message = display.newText(group, "Hit each target to pass", 0, 0, native.systemFont, 14);
        message.x, message.y = centerX, centerY+100;  
        popup:toFront()        
        message:toFront()        
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
        ragdogLib.setSaveValue("not_firstry2", true, true);
    end
    
    
    
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
            ragdogLib.setSaveValue("not_infinity_firstry2", true, true);
            
        end
        
        local mode = display.newText(group, "∞", 0, 0, native.systemFont, 50);
        mode.x, mode.y = centerX-100, centerY-260;
        
        --        local back = display.newText(group, "←", 0, 0, native.systemFont, 30);
        --        back.x, back.y = centerX-140, centerY-263;
        --        
        --        function back:touch(event)
        --            
        --            composer.gotoScene("menuScene", options)
        --        end
        --        
        --        back:addEventListener("touch", back);
        
    end     
    
    function barrel:enterFrame()
        self.rotation = self.rotation+barrelSpeed;
        barrel1.rotation=barrel1.rotation+barrelSpeed;
        barrel2.rotation=barrel2.rotation+barrelSpeed;
        barrel3.rotation=barrel3.rotation+barrelSpeed;
        barrel4.rotation=barrel4.rotation+barrelSpeed;
        barrel5.rotation=barrel5.rotation+barrelSpeed;
        
        if self.rotation > 360 then
            self.rotation = self.rotation-360;
        end
    end
    Runtime:addEventListener("enterFrame", barrel);
    
    
    barrel:toFront();
    
    local emptycrossbow = display.newImageRect(group, "IMG/EMPTY-CROSSBOW-01.png", 200, 140);
    emptycrossbow.x, emptycrossbow.y = centerX, centerY+215;
    emptycrossbow.isVisible=false;
    
    local crossbow = display.newImageRect(group, "IMG/CROSSBOW-01.png", 200, 140);
    crossbow.x, crossbow.y = centerX, centerY+215;
    
    --    local spawnTable = {}
    --    
    --    
    --    local function spawn()
    --        local object = display.newImageRect(group, "IMG/ARROW-01.png", 18, 31);
    --        return object
    --    end
    
    local arrow = display.newImageRect(group, "IMG/ARROW-01.png", 18, 31);
    arrow.x, arrow.y = centerX, crossbow.y-crossbow.contentHeight*.5-arrow.contentHeight*.5+15;
    arrow.xStart, arrow.yStart = arrow.x, arrow.y;
    arrow.state = 0;
    arrow.isVisible = false;
    
    
    function arrow:enterFrame()
        
        if self.state == 1 then
            if self.y-self.contentHeight*.5 <= barrel.y+barrel.height*.5 then
                self.isVisible = false;
                crossbow.isVisible=true;
                emptycrossbow.isVisible=false;
                print(barrel.rotation);
                
                local function hitObject ()
                    audio.play(arrowhitSFX, {channel = audio.findFreeChannel()});
                    if barrelSpeed == 0 then
                        barrelSpeed = barrelInitialSpeed;
                    else
                        barrelSpeed = barrelSpeed+speedIncreaseAtEveryPoint;
                        if barrelSpeed > maxCircleSpeed then
                            barrelSpeed = maxCircleSpeed;
                        end
                    end
                    
                    
                    currentScore = currentScore+3;    
                    print(targetHit)
                    
                    
                    
                    --                    transition.to(barrel, {time = 100, xScale = 1.1, yScale = 1.1});
                    --                    transition.to(barrel, {delay = 100, time = 50, xScale = 1, yScale = 1});
                    self.state = 0;
                    self.x, self.y = arrow.xStart, arrow.yStart;
                    if  not infinity then
                        
                        if targetHit >= 5 then 
                            myData.lv2_score = currentScore;
                            ragdogLib.setSaveValue("infinity2", true, true);
                            composer.gotoScene("levelPassedScene", options);
                        end
                        
                    end
                    
                end
                
                local function missObject()
                    audio.play(arrowhitSFX, {channel = audio.findFreeChannel()});
                    self.isVisible = true;
                    self.state = 2;
                    self.time = 0;
                    self.x, self.y =self.x, self.y-7;
                    
                    
                    barrelSpeed = 0;
                    
                end
                
                if (barrel.rotation >= t1min and barrel.rotation <= t1max) then
                    targetHit=targetHit+1;
                    hitObject() 
                    barrel1.isVisible=true;
                    barrel:toBack()
                    
                    
                elseif (barrel.rotation >= t2min and barrel.rotation <= t2max)then
                    targetHit=targetHit+1;
                    hitObject() 
                    barrel2.isVisible=true;
                    
                    
                elseif (barrel.rotation >= t3min and barrel.rotation <= t3max) then 
                    targetHit=targetHit+1;
                    hitObject()
                    barrel3.isVisible=true;
                    
                    
                elseif (barrel.rotation >= t4min and barrel.rotation <= t4max) then 
                    targetHit=targetHit+1;
                    hitObject() 
                    barrel4.isVisible=true;
                    
                    
                elseif (barrel.rotation >= t5min and barrel.rotation <= t5max) then 
                    
                    targetHit=targetHit+1;
                    hitObject()    
                    barrel5.isVisible=true;
                    
                    
                else
                    
                    missObject()
                    
                end
                
                
            end
            
            self.y = self.y-arrowSpeed;
        elseif self.state == 2 then
            self.time = self.time+1;
            if self.time >= 90 then
                Runtime:removeEventListener("enterFrame", self);
                myData.lv2_score = currentScore;
                -- barrel2:removeSelf()
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
    
    function bg:touch(event)
        
        native.showPopup( "activity", options );
        arrow.isVisible = true;
        crossbow.isVisible=false;
        emptycrossbow.isVisible=true;
        
        
        
        if event.phase == "began" then
            if arrow.state == 0 then
                arrow.state = 1;
                audio.play(shootSFX, {channel = audio.findFreeChannel()});
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
    
    local function onComplete( event )
        
        local action = event.action
        if "clicked" == event.action then
            if 1 == event.index then
                
            end
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
        audio.dispose(arrowhitSFX);
        arrowhitSFX = nil;
        --        audio.dispose(backgroundMusic);
        --        backgroundMusic = nil;
        audio.dispose(shootSFX);
        shootSFX = nil;
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

