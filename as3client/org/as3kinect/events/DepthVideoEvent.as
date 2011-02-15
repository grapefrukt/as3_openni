package org.as3kinect.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class DepthVideoEvent extends Event {
		
		public static const UPDATE_DEPTH:String = "as3kinectvideoevent_update_depth";
		public static const UPDATE_VIDEO:String = "as3kinectvideoevent_update_depth";
		
		public function DepthVideoEvent(type:String) { 
			super(type);
		} 
		
		public override function clone():Event { 
			return new DepthVideoEvent(type);
		} 
		
		public override function toString():String { 
			return formatToString("as3KinectVideoEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}