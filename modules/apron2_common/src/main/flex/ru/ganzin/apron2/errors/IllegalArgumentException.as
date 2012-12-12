package ru.ganzin.apron2.errors
{
	public class IllegalArgumentException extends Error
	{
		function IllegalArgumentException(message:String = null)
		{
			super(message);
		}
	}
}