package com.hurlant.util.asn1.parser {
	import com.hurlant.util.asn1.type.ASN1Type;
	import com.hurlant.util.asn1.type.PrintableStringType;

	public function printableString(size:int=-1,size2:int=0):ASN1Type {
		if (size == -1) size = int.MAX_VALUE;
		return new PrintableStringType(size, size2);
	}
}