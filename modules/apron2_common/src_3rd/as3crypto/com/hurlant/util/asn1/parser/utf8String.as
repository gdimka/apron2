package com.hurlant.util.asn1.parser {
	import com.hurlant.util.asn1.type.UTF8StringType;
	
	public function utf8String(size:int=-1,size2:int=0):UTF8StringType {
		if (size == -1) size = int.MAX_VALUE;
		return new UTF8StringType(size, size2);
	}
}