package ru.ganzin.apron2.data.weak
{
	import flash.utils.Dictionary;

	public class WeakRef
	{
		private var dic:Dictionary;
		
		public function WeakRef(obj:*)
		{
			dic=new Dictionary(true);
			dic[obj]=1;
		}

		public function get():*
		{
			for (var item:*in dic)
			{
				return item;
			}
			return null;
		}
	}
}