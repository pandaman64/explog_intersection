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

void main(){
	import std.stdio;
	import std.algorithm;
	import std.range;
	import std.math;

	auto seq = TetrationSequence(0.02);
	
	foreach(v;zip(
		seq.error_seq,
		seq.error_seq.adjacent_ratio,
		seq.error_seq.adjacent_difference
	).take(150).until!(a => abs(a[2]) <= pow(10.0,-8))){
		writefln("%.20f",v[0]);
		writefln("%.20f",v[1]);
		writefln("%.20f",v[2]);
		writeln();
		//writefln("%.20f\n%.20f\n",v[0],v[1]);
		//writefln("%.5f%%",v[1]/v[0]*100);
	}
}
