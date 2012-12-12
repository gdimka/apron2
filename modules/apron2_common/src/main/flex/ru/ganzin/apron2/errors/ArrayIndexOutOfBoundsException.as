package ru.ganzin.apron2.errors
{
	import ru.ganzin.apron2.utils.StringUtil;

	/**
	 * Thrown when attempting to access a position outside the valid range of
	 * an array. For example:<br>
	 * <pre>
	 * int[] i = { 1 };
	 * i[1] = 2;
	 * </pre>
	 */
	public class ArrayIndexOutOfBoundsException extends Error 
	{
		/**
		 * 
		 * Creates a new instance of AbstractError in which derived classes
		 * utilize to replace tokens in a specific error message
		 *
		 * @param the message String associated with the error
		 * @param arguments to replace tokens in error message
		 * 
		 */
		public function ArrayIndexOutOfBoundsException(...args)
		{
			var message:String = "Array index out of range: {0}";
			if (args[0] is String) message = args.shift();
			
			super(StringUtil.substitute(message, [args]));
		}
	}
}
