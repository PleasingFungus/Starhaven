package org.flixel.data 
{
	import com.facebook.Facebook;
	import com.facebook.events.FacebookEvent;
	import com.facebook.commands.stream.PublishPost;
	import com.facebook.commands.users.HasAppPermission;
	import com.facebook.data.BooleanResultData;
	import com.facebook.data.feed.ActionLinkData;
	import com.facebook.data.auth.ExtendedPermissionValues;
	import com.facebook.utils.FacebookSessionUtil;
	import flash.utils.Dictionary;
	
	import flash.display.LoaderInfo;
	
	import org.flixel.*
	
	/**
	 * ...
	 * @author WhenRaptorsAttack
	 */
	public class FlxFace extends FlxSprite
	{
		private var key:String;
		private var secret:String;
		private var fbook:Facebook;
		private var sess:FacebookSessionUtil;
		private var state:uint = 0;
		
		public function FlxFace(key:String,secret:String) 
		{
			super();
			this.key = key;
			this.secret = secret;
		}
		/**
		 * Connect to a user's facebook using your key and secret.
		 * 
		 * @param	loaderInfo		loaderinfo of your FlxState
		 * @param	callback		Pass a function to be called after it is connected.
		 */
		public function connect(loaderInfo:LoaderInfo, callback:Function):void {
			sess = new FacebookSessionUtil(key, secret,loaderInfo);
			fbook = sess.facebook;
			sess.addEventListener(FacebookEvent.WAITING_FOR_LOGIN, function(fbe:FacebookEvent):void {
				sess.validateLogin();
			});
			sess.addEventListener(FacebookEvent.CONNECT, function(fbe:FacebookEvent):void {
				if (!fbe.success) {
					sess.validateLogin();
				} else {
					callback(); // I can't believe that works... it shouldn't
				}
			});
			sess.login();
		}
		/**
		 * Post a message to a user's wall!
		 * 
		 * @param	message - the message, no markup
		 * @param	actionlinks - links that go along the footer of the message
		 * @param	data - Attachment data, see http://wiki.developers.facebook.com/index.php/Attachment_(Streams)
		 * @param	callback - optional callback that recieves a boolean of whether it successfully posted or not
		 */
		public function post(message:String, actionlinks:Array = null ,data:Object = null, callback:Function = null):void {
			if (data == null) data = { };
			var call:HasAppPermission = new HasAppPermission(ExtendedPermissionValues.PUBLISH_STREAM, fbook.uid)
           
			call.addEventListener(FacebookEvent.COMPLETE, function(fbe:FacebookEvent):void {
				var info:BooleanResultData = fbe.data as BooleanResultData;
				// Check if we can post
				if (!info.value) {
					fbook.grantExtendedPermission(ExtendedPermissionValues.PUBLISH_STREAM);
					if (callback != null) {
						callback(false);
					}
				} else {
					var als:Array = [];
					var temp:ActionLinkData;
					for (var item:String in actionlinks) {
						temp = new ActionLinkData();
						temp.href = actionlinks[item][0];
						temp.text = actionlinks[item][1];
						als.push(temp);
					}
					fbook.post(new PublishPost(message, data, als));
					if (callback != null) {
						callback(true);
					}
				}
			});
			fbook.post(call);
		}
		
	}
}