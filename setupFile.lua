--CHECK adsLib.lua TO ADD YOUR ADS KEYS
--CHECK build.settings TO FINALIZE SHARE/ADS
--CHECK level1Scene.lua TO CHANGE OTHER PARAMETERS RELATED TO THE GAME
local ragdogLib = require "ragdogLib";
local adsLib = require "adsLib";
local networksLib = require "networksLib";
local composer = require "composer";


local totalWidth = _G.totalWidth;
local totalHeight = _G.totalHeight;
local leftSide = _G.leftSide;
local rightSide = _G.rightSide;
local topSide = _G.topSide;
local bottomSide = _G.bottomSide;
local centerX = display.contentCenterX;
local centerY = display.contentCenterY;

_G.iOSappIDforRate = "981774771";
_G.twitterConsumerKey = "x6pDjQj3WB4s0aLwOfePoB4g6";
_G.twitterSecretKey = "tkjsDBnSn4zo3CBbTRmGVyOmdI6pUdqW43XFNq8be2kJSqSSFv";
_G.facebookAPPID = "213402122181674";


_G.socialShareMessage = "I just made totalPoints in the Tap To Shoot!";
_G.activeRemoveAdsButton = true;
_G.iApItems = {
  ["removeAds"] = {"com.goldcoin.taptoshoot.removeads"}, --modify com.ragdogstudios.removeAds with your own iAp ID (non-consumable product)
};


local activeNetworksProviders = {
  ["Android"] = {"google", "CgkIn5SqtbUFEAIQAQ"}, --replace "google" with "none" if you don't use any leaderboard!
  ["iPhone OS"] = {"gamecenter", "com.appgroupint.taptoshoot.Leaderboard"} --replace "gamecenter" with "none" if you don't use any leaderboard!
};


local function systemEvents( event )
   if ( event.type == "applicationSuspend" ) then
   elseif ( event.type == "applicationResume" ) then
   elseif ( event.type == "applicationExit" ) then
   elseif ( event.type == "applicationStart" ) then
      networksLib.init(activeNetworksProviders);
   end
   return true
end

Runtime:addEventListener( "system", systemEvents )

--CHECK TUTORIAL ON HOW TO SET ADS UP HERE http://ragdogstudios.com/2014/08/23/adslib-v2-how-to-implement-it-and-maximize-your-revenues/
local adsSettings = {
  ["iPhone"] = {
  ["main_menu"] = {
      mediationType = "order", --possible values are "order" and "percentage"
      adType = "interstitial",  --possible values are "banner" or "interstitial"
      frequency = 1,  --frequency defines how frequently the ad should appear. In this case, it'll take 2 main menus loads for the ad to show up every time.
      providers = {
        [1] = {
          providerName = "admob", --possible values are "chartboost", "revmob", "tapfortap", "admob", "iads", "playhaven"
          providerFallback = 1, --this defines the fallback provider. In this case, it falls back to the provider number 2 of this table, "revmob".
          mustBeCached = true,  --where supported, if the ad is not preloaded, it will fall back to the set provider until the ad is loaded.
        }
      }
    },
    ["game_over"] = {
      mediationType = "order", 
      adType = "interstitial",
      frequency = 1,
      keepOrderDuringSession = true,
      providers = {
        [1] = {
          providerName = "admob",
          providerFallback = 2,
          mustBeCached = true,
        },
        [2] = {
          providerName = "revmob",
          providerFallback = 1,
          mustBeCached = false
        }
      }
    },
    ["during_game"] = {
      mediationType = "order",
      adType = "banner",
      frequency = 1,
      adPosition = "bottom",
      keepOrderDuringSession = true,
      providers = {
        [1] = {
          providerName = "revmob",
          providerFallback = nil
        }
      }
    }
  },
  ["Android"] = {
   --native.showAlert( "Ads", "Android" ,{ "OK" });

  ["main_menu"] = {
      mediationType = "order", --possible values are "order" and "percentage"
      adType = "interstitial",  --possible values are "banner" or "interstitial"
      frequency = 1,  --frequency defines how frequently the ad should appear. In this case, it'll take 2 main menus loads for the ad to show up every time.
      providers = {
        [1] = {
          providerName = "admob", --possible values are "chartboost", "revmob", "tapfortap", "admob", "iads", "playhaven"
          providerFallback = 1, --this defines the fallback provider. In this case, it falls back to the provider number 2 of this table, "revmob".
          mustBeCached = true,  --where supported, if the ad is not preloaded, it will fall back to the set provider until the ad is loaded.
        }
      }
    },
    ["game_over"] = {
      mediationType = "order", 
      adType = "interstitial",
      frequency = 1,
      keepOrderDuringSession = true,
      providers = {
        [1] = {
          providerName = "admob",
          providerFallback = 2,
          mustBeCached = true,
        },
        [2] = {
          providerName = "revmob",
          providerFallback = 1,
          mustBeCached = false
        }
      }
    },
    ["during_game"] = {
      mediationType = "order",
      adType = "banner",
      frequency = 1,
      adPosition = "bottom",
      keepOrderDuringSession = true,
      providers = {
        [1] = {
          providerName = "revmob",
          providerFallback = nil
        }
      }
    }
  }
};

local activeAdsProviders = {
  ["Android"] = {"admob"}, -- possible values are "tapfortap", "admob", "playhaven", "revmob", "chartboost", "iads"
  ["iPhone"] = {"admob"} --it should include all the ads providers you've put in the adsSettings table
};
 

adsLib.init(activeAdsProviders, adsSettings);