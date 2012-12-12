package ru.ganzin.apron2.errors
{
	import ru.ganzin.apron2.utils.StringUtil;

	/**
     * 
     * Pseudo-abstract class which provides an API allowing derived
     * classes to pass a message containing tokens to be replaced 
     * with an arbitrary length of paramters
     *
     * @example Below is an example of how to sub-class 
     * AbstractError
     *
     * <listing version="3.0">
     * package
     * {
     *    public class SimpleError extends AbstractError
     *    {
     *        public static const MESSAGE:String = "Error {0}";
     *
     *        public function SimpleError(detail:String)
     *        {
     *             super( SimpleError.MESSAGE, detail );
     *        }
     * }
     * </listing>
     *
     */
	
	public class AbstractError extends Error 
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
        public function AbstractError(message:String, ...args)
        {
            super( StringUtil.substitute( message, [args] ) );
        }
	}
}
