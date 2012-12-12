package ru.ganzin.apron2.mvn.puremvc.fabrication
{
	import org.puremvc.as3.multicore.utilities.fabrication.components.FlexApplication;

	import ru.ganzin.apron2.mvn.puremvc.fabrication.fabricator.SimpleFlexApplicationFabricator;
	import ru.ganzin.apron2.mvn.puremvc.fabrication.pattern.command.startup.ModulesStartupCommand;

	/**
	 * Базовый класс для Flex приложений разработынных на MVC и Fabrication.
	 * Имплиментирует интерфейс IHasModules, что позволяет добавлять модули к приложению.
	 * 
	 * @author Димка
	 * @see apron.mvc.fabrication.IHasModules IHasModules
	 * 
	 */	
	public class SimpleFlexApplication extends FlexApplication implements IHasModules
	{
		/**
		 * Логгер
		 */		

		private var modules:Array = new Array();
		
		public function SimpleFlexApplication()
		{
			super();
		}
		/**
		 * Добавляет модуль для приложения.
		 * @param module Модуль реализованый на MVC и Fabrication.
		 * 
		 */		
		public function addModule(module:IModule):void
		{
			modules.push(module);
		}
		
		/**
		 * @internal
		 * Функция инициализации модулей. Выполняется в комманде ModulesStartupCommand.
		 * 
		 */		
		public function initModules():void
		{
			for each (var module:SimpleModule in modules)
			{
				module.parentApplication = this as IHasModules;
				module.init();
			}
		}
		
//		public function getApplicationRunCommmand():Class
//		{
//			return null;
//		}

		/**
		 * Возвращает комманду инициализации модулей.
		 */		
		public function getModulesStartupCommand():Class
		{
			return ModulesStartupCommand;
		}
		
		//-------------------------------------------------
		//	Overrided Medhods
		//-------------------------------------------------
		
		/**
		 *  @inheritDoc
		 */		
		override public function initializeFabricator():void
		{
			_fabricator = new SimpleFlexApplicationFabricator(this);
		}
		

	}
}