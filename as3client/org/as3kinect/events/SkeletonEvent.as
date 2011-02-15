package org.as3kinect.events {
	import flash.events.Event;
	import org.as3kinect.objects.Skeleton3D;
	
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class SkeletonEvent extends Event {
		
		public static const UPDATE:String = "as3kinectskeletonevent_update";
		
		private var _skeleton:Skeleton3D;
		
		public function SkeletonEvent(type:String, skeleton:Skeleton3D) { 
			super(type);
			_skeleton = skeleton;
			
		} 
		
		public override function clone():Event { 
			return new SkeletonEvent(type, _skeleton);
		} 
		
		public function get skeleton():Skeleton3D { return _skeleton; }
		
	}
	
}