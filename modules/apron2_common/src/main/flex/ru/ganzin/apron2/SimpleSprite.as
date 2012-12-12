package ru.ganzin.apron2
{
	import flash.display.Sprite;

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.logging.api.getNamedLogger;

	public class SimpleSprite extends Sprite
	{
		private static var count:uint = 0;

		private var _uid:uint = count++;
		apron_internal function get uid():uint
		{
			return _uid;
		}

		private var _cachedClassName:String;

		public function getClassName():String
		{
			if (_cachedClassName) return _cachedClassName;
			return _cachedClassName = ClassUtils.getName(getClass());
		}

		private var _cachedFullClassName:String;

		public function getFullyClassName():String
		{
			if (_cachedFullClassName) return _cachedFullClassName;
			return _cachedFullClassName = ClassUtils.getFullyQualifiedName(getClass(), true);
		}

		private var _cachedClass:Class;

		public function getClass():Class
		{
			if (_cachedClass) return _cachedClass;
			return _cachedClass = ClassUtils.forInstance(this);
		}

		private var _logger:ILogger;
		protected final function set logger(value:ILogger):void
		{
			_logger = value;
		}

		protected final function get logger():ILogger
		{
			if (_logger) return _logger;
			_logger = getClassLogger(getClass());
			return _logger;
		}

		private var _loggerWithUid:ILogger;
		protected final function getLoggerWithUid():ILogger
		{
			if (_loggerWithUid) return _loggerWithUid;
			_loggerWithUid = getNamedLogger(getFullyClassName().replace("::", ".")+"."+_uid);
			return _loggerWithUid;
		}

		protected final function getLogger(name:String = null):ILogger
		{
			if (name == null) return logger;
			else return getNamedLogger(name);
		}
	}
}

