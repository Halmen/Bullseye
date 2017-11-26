
_G.totalWidth = display.contentWidth-(display.screenOriginX*2);
_G.totalHeight = display.contentHeight-(display.screenOriginY*2);
_G.leftSide = display.screenOriginX;
_G.rightSide = display.contentWidth-display.screenOriginX;
_G.topSide = display.screenOriginY;
_G.bottomSide = display.contentHeight-display.screenOriginY;


local ragdogLib = require "ragdogLib";
local setupFile = require "setupFile";
local composer = require "composer";
local ads = require( "ads" )
local myData = require "myData";
local event="buff";

composer.recycleOnSceneChange = true;

display.setStatusBar(display.HiddenStatusBar);
    
ads.init( myData.adProvider, myData.appID, myData.adListener(event) )
ads.show( "banner", { x=0, y=-45, appId=myData.bannerAppID } )     
composer.gotoScene("menuScene", "fade");


