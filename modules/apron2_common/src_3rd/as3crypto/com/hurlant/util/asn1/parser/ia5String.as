package com.hurlant.util.asn1.parser {
	import com.hurlant.util.asn1.type.IA5StringType;
	
	public function ia5String(size:int=-1,size2:int=0):IA5StringType {
		if (size == -1) size = int.MAX_VALUE;
		return new IA5StringType(size, size2);
	}
}