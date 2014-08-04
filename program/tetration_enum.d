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

struct AdjacentRange(alias Func,Range){
private:
	Range range;
public:
	this(Range r){
		range = r;
	}
	
	bool empty() @safe{
		return range.empty;
	}
	
	void popFront(){
		range.popFront;
	}
	
	auto front(){
		auto forward = range;
		forward.popFront();
		return Func(forward.front,range.front);
	}
	
	auto save(){
		return this;
	}
}
auto adjacent_range(alias Func,Seq)(Seq seq){
	return AdjacentRange!(Func,Seq)(seq);
}
auto adjacent_difference(Seq)(Seq seq){
	return adjacent_range!((a,b) => a-b)(seq);
}
auto adjacent_ratio(Seq)(Seq seq){
	return adjacent_range!((a,b) => a/b)(seq);
}

Number rate_of_convergence(Number base,Number precision = 8){
	import std.algorithm : zip,take,until;
	import std.math : abs,pow;
	
	auto seq = TetrationSequence(base);
	
	auto rate = zip(
		seq.error_seq,
		seq.error_seq.adjacent_ratio,
		seq.error_seq.adjacent_difference
	).take(150).until!(a => abs(a[2]) <= pow(10.0,-precision));
	
	return rate.front[1];
}

void main(){
	import std.stdio;
	import std.algorithm;
	import std.range;
	import std.math;

	writeln(0.02,",",rate_of_convergence(0.02));
}
