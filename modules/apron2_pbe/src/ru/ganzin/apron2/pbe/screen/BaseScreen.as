package ru.ganzin.apron2.pbe.screen
{
	import com.pblabs.screens.BaseScreen;

	import flash.utils.getQualifiedClassName;

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;

	public class BaseScreen extends com.pblabs.screens.BaseScreen
	{
		private var _logger:ILogger;

		private var _cachedClassName:String;
		public function getClassName():String
		{
			if (_cachedClassName) return _cachedClassName;
			return _cachedClassName = getQualifiedClassName(this);
		}

		private var _cachedClass:Class;
		public function getClass():Class
		{
			if (_cachedClass) return _cachedClass;
			return _cachedClass = ClassUtils.forInstance(this);
		}

		protected final function set logger(value:ILogger):void
		{
			_logger = value;
		}

		protected final function get logger():ILogger
		{
			if (_logger) return _logger;
			_logger = LoggerFactory.getClassLogger(getClass());
			return _logger;
		}

		protected final function getLogger(name:String = null):ILogger
		{
			if (name == null) return logger;
			else return LoggerFactory.getLogger(name);
		}
	}
}