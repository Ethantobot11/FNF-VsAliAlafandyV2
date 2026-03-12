package debug;

import flixel.FlxG;
// import flixel.FlxSprite;
// import flixel.util.FlxTimer;

import backend.MusicBeatState;

import states.WarningState;
import states.TitleState;

#if VIDEOS_ALLOWED
#if (hxCodec >= "3.0.0")
import hxcodec.flixel.FlxVideo as VideoHandler;
#elseif (hxCodec >= "2.6.1")
import hxcodec.VideoHandler as VideoHandler;
#elseif (hxCodec == "2.6.0")
import VideoHandler;
#else
import vlc.MP4Handler as VideoHandler;
#end
#end

class SplashIntroVideo extends MusicBeatState
{
    override function create()
    {
        super.create();

        #if VIDEOS_ALLOWED
        startVideo("alafandy_intro");
        #else
        finishVideo();
        #end
    }

    #if VIDEOS_ALLOWED
    function startVideo(name:String)
    {
        #if VIDEOS_ALLOWED
        var filepath:String = Paths.video(name);
        #if sys
        if(!FileSystem.exists(filepath))
        #else
        if(!OpenFlAssets.exists(filepath))
        #end
        {
            FlxG.log.warn('Couldnt find video file: ' + name);
            finishVideo();
            return;
        }
        var video:VideoHandler = new VideoHandler();
            #if (hxCodec >= "3.0.0")
            // Recent versions
            video.play(filepath);
            video.onEndReached.add(function()
            {
                video.dispose();
                finishVideo();
                return;
            }, true);
            #else
            // Older versions
            video.playVideo(filepath);
            video.finishCallback = function()
            {
                finishVideo();
                return;
            }
            #end
        #else
        FlxG.log.warn('Platform not supported!');
        return;
        #end
    }
    #end

    function finishVideo()
    {
        if(FlxG.save.data.flashing == null && !WarningState.leftState)
        {
            MusicBeatState.switchState(new WarningState());
        } else {
            MusicBeatState.switchState(new TitleState());
        }
    }
}
