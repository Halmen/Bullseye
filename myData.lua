local ragdogLib = require "ragdogLib";



local M = {
    
    --add:
    bannerAppID = "ca-app-pub-9018848301782074/6852816341"; --for your iOS banner
    interstitialAppID = "ca-app-pub-9018848301782074/8205440748"; --for your iOS interstitial
    appID="581588654369";
    adProvider = "admob";
    
    --audio:
    buttonSFX = audio.loadSound("SFX/Button_Select.mp3");
    mainMenuBgMusic=audio.loadStream("SFX/menu.mp3");
    Lv1BgMusic=audio.loadStream("SFX/futuristic relaxing music.mp3"); 
    Lv2BgMusic=audio.loadStream("SFX/Fantasy Medieval Music - Rise of a Kingdom.mp3");
    
    
    
    --images:
    backButton =  "IMG/TRY-NEW@4x.png";
    
    
    
    --variables&functions:
    lv1_score=0;
    lv2_score=0;
    death=0;
    
    adListener=function(event)
        
        local msg = event.response
        -- Quick debug message regarding the response from the library
        print( "Message from the ads library: ", msg )
        
        if ( event.isError ) then
            print( "Error, no ad received", msg )
        else
            print( "Ah ha! Got one!" )
        end
        
        
    end;
    
    
    getLv1beset=function(lv1_score)
        
        local lv1_bestScore = ragdogLib.getSaveValue("lv1_bestScore") or 0;
        
        if lv1_bestScore < lv1_score then
            lv1_bestScore = lv1_score;
            ragdogLib.setSaveValue("lv1_bestScore", lv1_bestScore, true);
            --networksLib.addScoreToLeaderboard(lv1_bestScore);
        end 
        
        return lv1_bestScore;
    end;
    
    getLv2beset=function(lv2_score)
        
        local lv2_bestScore = ragdogLib.getSaveValue("lv2_bestScore") or 0;
        
        if lv2_bestScore < lv2_score then
            lv2_bestScore = lv2_score;
            ragdogLib.setSaveValue("lv2_bestScore", lv2_bestScore, true);
            --networksLib.addScoreToLeaderboard(lv2_bestScore);
        end 
        
        return lv2_bestScore;
    end;
    
}



return M

