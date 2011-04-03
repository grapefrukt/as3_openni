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

 
package org.as3kinect.objects {
	
	import org.as3kinect.objects.Point3D;
	import flash.utils.ByteArray;
	
	public class Skeleton3D {
		
		public var userID		:uint;
		public var head			:Point3D;
		public var neck			:Point3D;
		public var shoulderL	:Point3D;
		public var elbowL		:Point3D;
		public var handL		:Point3D;
		public var shoulderR	:Point3D;
		public var elbowR		:Point3D;
		public var handR		:Point3D;
		public var torso		:Point3D;
		public var hipL			:Point3D;
		public var kneeL		:Point3D;
		public var footL		:Point3D;
		public var hipR			:Point3D;
		public var kneeR		:Point3D;
		public var footR		:Point3D;
		
		public function Skeleton3D(userId:uint):void {
			userID    = userId;
			head      = new Point3D();
			neck      = new Point3D();
			shoulderL = new Point3D();
			elbowL    = new Point3D();
			handL     = new Point3D();
			shoulderR = new Point3D();
			elbowR    = new Point3D();
			handR     = new Point3D();
			torso     = new Point3D();
			hipL      = new Point3D();
			kneeL     = new Point3D();
			footL     = new Point3D();
			hipR      = new Point3D();
			kneeR     = new Point3D();
			footR     = new Point3D();
		}
	}
}
