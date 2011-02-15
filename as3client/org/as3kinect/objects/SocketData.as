package org.as3kinect.objects {
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class SocketData {
		
		public var firstByte	:int;
		public var secondByte	:int;
		public var buffer		:ByteArray;
		
		public function SocketData():void {
			buffer = new ByteArray;
		}
		
	}

}