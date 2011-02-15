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
	
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import org.as3kinect.as3kinect;
	import org.as3kinect.events.SkeletonEvent;
	import org.as3kinect.objects.Point3D;
	import org.as3kinect.objects.Skeleton3D;
	
	
	[Event(name = "as3kinectskeletonevent_update", type = "org.as3kinect.events.SkeletonEvent")]
	
	public class SkeletonManager extends EventDispatcher {
		private var _socket:SocketManager;
		private var _data:ByteArray;
		private var _busy:Boolean;
		
		private var _skeletons:Dictionary;
		
		public function SkeletonManager(socket:SocketManager){
			_socket = socket;
			_data = new ByteArray;
			_busy = false;
			_skeletons = new Dictionary();
		}

		/*
		 * Tell server to send the latest skeleton data
		 * Note: We should lock the command while we are waiting for the data to avoid lag
		 */
		public function getSkeletons():void {
			if (_busy) return;
			
			_busy = true;
			_data.clear();
			_data.writeByte(as3kinect.CAMERA_ID);
			_data.writeByte(as3kinect.GET_SKEL);
			_data.writeInt(0);
			if(_socket.sendCommand(_data) != as3kinect.SUCCESS){
				throw new Error('Data was not complete');
			}
		}
		
		public function process(data:ByteArray):void {
			_busy = false;
			var userId:uint = data.readInt();
			var skeleton:Skeleton3D = _skeletons[userId];
			
			// todo: for some reason, skeletons arrive before the user is added
			if (!skeleton) skeleton = addUser(userId);
			
			updateSkeletonFromBytes(_skeletons[userId], data);
			dispatchEvent(new SkeletonEvent(SkeletonEvent.UPDATE, _skeletons[userId]));
		}
		
		public function addUser(userId:Number):Skeleton3D {
			return _skeletons[userId] = new Skeleton3D(userId);
		}
		
		public function removeUser(userId:Number):void {
			delete _skeletons[userId];
		}
		
		private function updateSkeletonFromBytes(skeleton:Skeleton3D, data:ByteArray):void {
			updatePointFromBytes(skeleton.head, data);
			updatePointFromBytes(skeleton.neck, data);
			updatePointFromBytes(skeleton.shoulderL, data);
			updatePointFromBytes(skeleton.elbowL, data);
			updatePointFromBytes(skeleton.handL, data);
			updatePointFromBytes(skeleton.shoulderR, data);
			updatePointFromBytes(skeleton.elbowR, data);
			updatePointFromBytes(skeleton.handR, data);
			updatePointFromBytes(skeleton.torso, data);
			updatePointFromBytes(skeleton.hipL, data);
			updatePointFromBytes(skeleton.kneeL, data);
			updatePointFromBytes(skeleton.footL, data);
			updatePointFromBytes(skeleton.hipR, data);
			updatePointFromBytes(skeleton.kneeR, data);
			updatePointFromBytes(skeleton.footR, data);
		}
		
		private function updatePointFromBytes(point:Point3D, data:ByteArray):void {
			point.x = data.readFloat();
			point.y = data.readFloat();
			point.z = data.readFloat();
		}
		
		public function get busy():Boolean { return _busy; }
		public function get skeletons():Dictionary { return _skeletons; }
	}
}
