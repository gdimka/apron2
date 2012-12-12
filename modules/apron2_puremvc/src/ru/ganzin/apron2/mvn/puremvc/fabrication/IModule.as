package ru.ganzin.apron2.mvn.puremvc.fabrication
{
	public interface IModule
	{
		function init():void;
		function get parentApplication():IHasModules;
		function set parentApplication(value:IHasModules):void;
	}
}