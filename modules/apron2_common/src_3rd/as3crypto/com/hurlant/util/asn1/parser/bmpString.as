package com.hurlant.util.asn1.parser {
	import com.hurlant.util.asn1.type.BMPStringType;
	
	public function bmpString(size:int=-1,size2:int=0):BMPStringType {
		if (size == -1) size = int.MAX_VALUE;
		return new BMPStringType(size, size2);
	}
}