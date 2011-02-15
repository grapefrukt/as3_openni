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
	 
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import org.as3kinect.as3kinect;
	import org.as3kinect.events.SocketEvent;
	import org.as3kinect.objects.SocketData;
	

	/**
	 * as3kinectSocket class recieves Kinect data from the as3kinect driver.
	 */
	public class SocketManager extends EventDispatcher
	{
	
		private var _socket		:Socket;
		private var _port		:Number;
		
		private var _packet_size:Number;
		private var _data		:SocketData;

		public function SocketManager()
		{		
			_socket = new Socket();
			_data = new SocketData;
			
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketError);
			_socket.addEventListener(Event.CONNECT, onSocketConnect);
		}
		
		public function connect(host:String, port:uint):void
		{
			_port = port;
			_packet_size = 0;
			if (!this.connected) 
				_socket.connect(host, port);
			else
				dispatchEvent(new SocketEvent(SocketEvent.CONNECT, null));
		}
		
		public function get connected():Boolean
		{
			return _socket.connected;
		}
		
		public function close():void
		{
			_socket.close();
		}
		
		public function sendCommand(data:ByteArray):int {
			if (!connected) return as3kinect.ERROR;
			
			if(data.length == as3kinect.COMMAND_SIZE){
				_socket.writeBytes(data, 0, as3kinect.COMMAND_SIZE);
				_socket.flush();
				return as3kinect.SUCCESS;
			} else {
				throw new Error( 'Incorrect data size (' + data.length + '). Expected: ' + as3kinect.COMMAND_SIZE);
				return as3kinect.ERROR;
			}
		}
		
		private function onSocketData(event:ProgressEvent):void
		{
			if(_socket.bytesAvailable > 0) {
				if(_packet_size == 0) {
					_socket.endian = Endian.LITTLE_ENDIAN;
					_data.firstByte = _socket.readByte();
					_data.secondByte = _socket.readByte();
					_packet_size = _socket.readInt();
				}
				if(_socket.bytesAvailable >= _packet_size && _packet_size != 0){
					_socket.readBytes(_data.buffer, 0, _packet_size);
					_data.buffer.endian = Endian.LITTLE_ENDIAN;
					_data.buffer.position = 0;
					_packet_size = 0;
					dispatchEvent(new SocketEvent(SocketEvent.DATA, _data));
				}
			}
		}
		
		private function onSocketError(event:IOErrorEvent):void{
			dispatchEvent(new SocketEvent(SocketEvent.ERROR, null));
		}
		
		private function onSocketConnect(event:Event):void{
			dispatchEvent(new SocketEvent(SocketEvent.CONNECT, null));
		}
	}
}