/*
 * This file is part of the as3kinect Project. http://www.as3kinect.org
 *
 * Copyright (c) 2010 individual as3kinect contributors. See the CONTRIB file
 * for details.
 *
 * This code is licensed to you under the terms of the Apache License, version
 * 2.0, or, at your option, the terms of the GNU General Public License,
 * version 2.0. See the APACHE20 and GPL2 files for the text of the licenses,
 * or the following URLs:
 * http://www.apache.org/licenses/LICENSE-2.0
 * http://www.gnu.org/licenses/gpl-2.0.txt
 *
 * If you redistribute this file in source form, modified or unmodified, you
 * may:
 *   1) Leave this header intact and distribute it under the same terms,
 *      accompanying it with the APACHE20 and GPL20 files, or
 *   2) Delete the Apache 2.0 clause and accompany it with the GPL2 file, or
 *   3) Delete the GPL v2 clause and accompany it with the APACHE20 file
 * In all cases you must keep the copyright notice intact and include a copy
 * of the CONTRIB file.
 *
 * Binary distributions must follow the binary distribution requirements of
 * either License.
 */

 package org.as3kinect {
	
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import org.as3kinect.AS3Kinect;
	import org.as3kinect.events.SocketEvent;
	import org.as3kinect.managers.DepthManager;
	import org.as3kinect.managers.SkeletonManager;
	import org.as3kinect.managers.SocketManager;
	
	
	public class AS3KinectWrapper extends EventDispatcher {

		private var _socket		:SocketManager;
		private var _console	:TextField;
		private var _debugging	:Boolean = false;
		private var _user_id	:Number;
		
		private var _depth		:DepthManager;
		private var _skeleton	:SkeletonManager;

		public function AS3KinectWrapper(server:String = "localhost", port:uint = 6001) {
			_socket = new SocketManager();
			
			_depth = new DepthManager(_socket);
			_skeleton = new SkeletonManager(_socket);
			
			_socket.connect(server, port);
			_socket.addEventListener(SocketEvent.DATA, dataReceived);
		}

		/*
		 * dataReceived from socket (Protocol definition)
		 * Metadata comes in the first and second value of the data object
		 * first:
		 *	0 -> Camera data
		 * 			second:
		 *  			0 -> Depth ARGB received
		 *  			1 -> Video ARGB received
		 *  			2 -> Skeleton data received
		 *	1 -> Motor data
		 *	2 -> Microphone data
		 *	3 -> Server data
		 * 			second:
		 *  			0 -> Debug info received
		 *  			1 -> Got user
		 *  			2 -> Lost user
		 *  			3 -> Pose detected for user
		 *  			4 -> Calibrating user
		 *  			5 -> Calibration complete for user
		 *  			6 -> Calibration failed for user
		 *
		 */
		private function dataReceived(event:SocketEvent):void{
			// Send ByteArray to position 0
			event.data.buffer.position = 0;
			switch (event.data.firstByte) {
				case 0: //Camera
					switch (event.data.secondByte) {
						case 0: //Depth received
							_depth.process(event.data.buffer);
						break;
						case 1: //Video received
							//dispatchEvent(new AS3KinectWrapperEvent(AS3KinectWrapperEvent.ON_DEPTH, event.data));
						break;
						case 2: //SKEL received
							_skeleton.process(event.data.buffer);
						break;
					}
				break;
				case 1: //Motor
				break;
				case 2: //Mic
				break;
				case 3: //Server
					switch (event.data.secondByte) {
						case 0: //Debug received
							if(_debugging) _console.appendText(event.data.buffer.toString());
						break;
						case 1: //Got user
							_user_id = event.data.buffer.readInt();
							if (_debugging) _console.appendText("Got user: " + _user_id + "\n");
						break;
						case 2: //Lost user
							_user_id = event.data.buffer.readInt();
							if(_debugging) _console.appendText("Lost user: " + _user_id + "\n");
							_skeleton.removeUser(_user_id);
						break;
						case 3: //Pose detected
							_user_id = event.data.buffer.readInt();
							if(_debugging) _console.appendText("Pose detected for user: " + _user_id + "\n");
						break;
						case 4: //Calibrating
							_user_id = event.data.buffer.readInt();
							if(_debugging) _console.appendText("Calibrating user: " + _user_id + "\n");
						break;
						case 5: //Calibration complete
							_user_id = event.data.buffer.readInt();
							if(_debugging) _console.appendText("Calibration complete for user: " + _user_id + "\n");
							_skeleton.addUser(_user_id);
						break;
						case 6: //Calibration failed
							_user_id = event.data.buffer.readInt();
							if(_debugging) _console.appendText("Calibration failed for user: " + _user_id + "\n");
						break;
					}
				break;
			}
			// Clear ByteArray after used
			event.data.buffer.clear();
		}
		
		/*
		 * Enable log console on TextField
		 */
		public function set logConsole(txt:TextField):void{
			_debugging = true;
			_console = txt;
			_console.text = "=== Started console ===\n";
		}
		
		public function get depth():DepthManager { return _depth; }
		public function get skeleton():SkeletonManager { return _skeleton; }
		public function get socket():SocketManager { return _socket; }
	}
	
}
