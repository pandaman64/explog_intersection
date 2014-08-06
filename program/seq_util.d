module seq_util;

template fork(Pred...){
	auto fork(Range)(Range r){
		import std.algorithm : zip;
		import std.range : iota;
		import std.string : format;
		import std.functional : unaryFun;
		
		return zip(mixin (q{%(unaryFun!(Pred[%s])(r)%|,%)}.format(iota(0,Pred.length))),r);
	}
}

auto merge(alias Pred,Zipped)(Zipped range){
	import std.algorithm : map;
	return map!(t => Pred(t.expand))(range);
}

auto adjacent_difference(Range)(Range range){
	import std.range : dropOne;
	return range.fork!dropOne.merge!((a,b) => a - b);
}
auto adjacent_ratio(Range)(Range range){
	import std.range : dropOne;
	return range.fork!dropOne.merge!((a,b) => a / b);
}	
