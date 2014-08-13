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

auto adjacent_range(Range)(Range range){
	import std.range : dropOne;
	return range.fork!dropOne;
}

auto adjacent_difference(Range)(Range range){
	import std.range : dropOne;
	return range.adjacent_range.merge!((a,b) => a - b);
}
auto adjacent_ratio(Range)(Range range){
	import std.range : dropOne;
	return range.adjacent_range.merge!((a,b) => a / b);
}	

template limit_value(alias Pred){
	auto limit_value(Range)(Range range){
		import std.algorithm : find;
		return range.adjacent_range.find!(v => Pred(v[0],v[1])).front[1];
	}
}

template absolute_error(int precision){
	bool absolute_error(T)(T lhs,T rhs){
		import std.math : pow,abs;
		return abs(lhs - rhs) < pow(10.0,-precision);
	}
}
template relative_error(int precision){
	bool relative_error(T)(T lhs,T rhs){
		import std.math : pow,abs;
		return abs((lhs - rhs) / lhs) < pow(10.0,-precision);
	}
}
template effective_digit(int precision){
	bool effective_digit(T)(T lhs,T rhs){
		import std.math : log10,abs;
		return log10(abs(lhs / (lhs - rhs))) > precision;
	}
}
