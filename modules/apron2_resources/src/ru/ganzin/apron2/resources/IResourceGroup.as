package ru.ganzin.apron2.resources
{
	import org.as3commons.collections.framework.ILinkedListIterator;
	import org.as3commons.collections.framework.IMapIterator;

	public interface IResourceGroup
	{
		function get name():String;
		
		function getResourceGroup(groupName:String, locale:String = null):IResourceGroup;
		
		function getClass(resourceName:String, locale:String = null):Class

		function getObject(resourceName:String, locale:String = null):Object

		function getInt(resourceName:String, locale:String = null):int

		function getUint(resourceName:String, locale:String = null):uint

		function getNumber(resourceName:String, locale:String = null):Number

		function getString(resourceName:String, parameters:Array = null, locale:String = null):String

		function getStringArray(resourceName:String, locale:String = null):Array

		function getBoolean(resourceName:String, locale:String = null):Boolean

		function addResource(resourceName:String, value:Object, locale:String = null):*
		
		function hasResource(resourceName:String, locale:String = null):Boolean

		function getResourcesIterator(locale:String = null):IMapIterator;

		function addResourceGroup(group:IResourceGroup = null, locale:String = null):void

		function hasResourceGroup(groupName:String, locale:String = null):Boolean

		function getResourceGroupsCount(locale:String = null):uint;

		function getResourceGroupsIterator(locale:String = null):ILinkedListIterator;
	}
}
