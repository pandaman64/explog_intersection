import seq_util;

alias Number = real;

Number next_tetration(Number base,Number value){
	import std.math : pow;
	return pow(base,pow(base,value));
}

//calculate tetration to infinity
//Infinite & Forward range concept
struct TetrationSequence{
private:
	Number base;
	Number value;
public:	
	this(Number v){
		base = value = v;
	}
	
	enum bool empty = false;
	
	void popFront(){
		value = next_tetration(base,value);
	}
	
	Number front() @safe{
		return value;
	}
	
	auto save(){
		return this;
	}
}

struct ErrorSequence(Range){
private:
	import std.range : ElementType;
	
	Range range;
	ElementType!Range limit;
public:
	this(Range r,size_t num){
		import std.range : drop;
		
		range = r;
		limit = r.drop(num).front;
	}

	enum bool empty = false;
	
	void popFront(){
		range.popFront;
	}
	
	Number front() @safe{
		import std.math : abs;
		return abs(range.front - limit);
	}
	
	auto save(){
		return this;
	}
}
auto error_seq(Range)(Range r,size_t num = 100){
	return ErrorSequence!Range(r,num);
}

template rate_of_convergence(int precision = 8){
	Number rate_of_convergence(Number base){
		import std.algorithm : zip,find;
		import std.math : abs,pow;

		auto seq = TetrationSequence(base);
		return seq.error_seq.adjacent_ratio.limit_value!(effective_digit!precision);;
	}
}

void main(){
	import std.stdio;
	import std.range;
	import std.math;

	foreach(base;iota(0.001,pow(1.0/exp(1.0),exp(1.0)),0.001)){
		writeln(base,',',rate_of_convergence!4(base));
	}
}
