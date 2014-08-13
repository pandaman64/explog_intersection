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

Number rate_of_convergence(Number base,Number precision = 8){
	import std.algorithm : zip,find;
	import std.math : abs,pow;
	
	auto seq = TetrationSequence(base);
	
	auto rate = zip(
		seq.error_seq,
		seq.error_seq.adjacent_ratio,
		seq.error_seq.adjacent_difference
	).find!(a => abs(a[2]) <= pow(10.0,-precision));
	
	return rate.front[1];
}

void main(){
	import std.stdio;
	import std.range;
	import std.math;
	
	auto seq = TetrationSequence(0.03);
	seq.limit_value!(absolute_error!8).writeln;
	seq.limit_value!(effective_digit!5).writeln;
}
