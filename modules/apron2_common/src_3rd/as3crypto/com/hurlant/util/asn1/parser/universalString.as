package com.hurlant.util.asn1.parser {
	import com.hurlant.util.asn1.type.UniversalStringType;
	
	public function universalString(size:int=-1,size2:int=0):UniversalStringType {
		if (size == -1) size = int.MAX_VALUE;
		return new UniversalStringType(size, size2);
	}
}