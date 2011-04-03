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

package org.as3kinect.managers {
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import org.as3kinect.AS3Kinect;
	import org.as3kinect.Utilities;
	import org.as3kinect.events.DepthVideoEvent;
	
	public class DepthManager extends EventDispatcher {
		private var _socket	:SocketManager;
		private var _data	:ByteArray;
		private var _busy	:Boolean;
		private var _bitmap	:BitmapData;

		public function DepthManager(socket:SocketManager){
			_socket = socket;
			_data = new ByteArray;
			_busy = false;
			_bitmap = new BitmapData(AS3Kinect.IMG_WIDTH, AS3Kinect.IMG_HEIGHT, false, 0);
		}

		/*
		 * Tell server to send the latest depth frame
		 * Note: We should lock the command while we are waiting for the data to avoid lag
		 */
		public function getBuffer():void {
			if (_busy) return;
			_busy = true;
			_data.clear();
			_data.writeByte(AS3Kinect.CAMERA_ID);
			_data.writeByte(AS3Kinect.GET_DEPTH);
			_data.writeInt(0);
			if(_socket.sendCommand(_data) != AS3Kinect.SUCCESS){
				throw new Error('Data was not complete');
			}
		}
		
		public function process(data:ByteArray):void{
			Utilities.byteArrayToBitmapData(data, _bitmap);
			_busy = false;
			dispatchEvent(new DepthVideoEvent(DepthVideoEvent.UPDATE_DEPTH));
		}
		
		public function get busy():Boolean { return _busy; }
		public function get bitmap():BitmapData { return _bitmap; }

	}
}
