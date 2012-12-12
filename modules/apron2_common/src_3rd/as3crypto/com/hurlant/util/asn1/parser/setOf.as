package com.hurlant.util.asn1.parser {
	import com.hurlant.util.asn1.type.ASN1Type;
	import com.hurlant.util.asn1.type.SetType;
	
	public function setOf(type:ASN1Type, min:uint=0, max:uint=0):ASN1Type {
		return new SetType(type); // XXX ignoring min and max
	}
}