package;

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

import backend.MusicBeatState;

import flixel.FlxG;
import flixel.util.FlxTimer;

class FlxSplashIntro extends MusicBeatState
{
	#if VIDEOS_ALLOWED
	var videoInstance:VideoHandler;
	#end
	
	override function create()
	{
		super.create();
		
		#if VIDEOS_ALLOWED
		videoInstance = new VideoHandler();
		
		FlxG.game.addChild(videoInstance);
		
		if (videoInstance.load(Paths.video('alafandy_intro')))
		{
			videoInstance.onEndReached.add(exitState, true);
			
			FlxTimer.wait(0.001, () -> {
				videoInstance.play();
			});
		}
		else
		#end
		{
			exitState();
		}
	}
	
	function exitState()
	{
		#if VIDEOS_ALLOWED
		FlxG.game.removeChild(videoInstance);
		videoInstance?.dispose();
		videoInstance = null;
		#end
		
		MusicBeatState.switchState(new TilteState());
	}
}
