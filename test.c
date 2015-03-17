int f(int p1, int p2, int p3) {
	if(p3 > 0) {
		return p1 + p2;
	}

	return p1 * p2;
}

int fact(int val) {
	if(val > 0) {
		return val * fact(val - 1);
	}
	return 1;
}

int fib(int n) {
	if(n > 1) {
		return fib(n - 1) + fib(n - 2);
	}
	else {
		if(n == 1) {
			return 1;
		}
	}
	return 0;
}

int func3(int a, int b, int d) {
	int c = d * a + b;
	printf(c);
	f(b, a, 1);
	return a + b;
}
int func2() {
	printf(222222);
	return 2;

}
int func() {
	printf(1111111);
	func2();
	printf(3333333);
	func2();
	printf(111);
	return 1;
}

int testConst(const a, int b) {
	printf(b);

	return 0;
}

int main() {
	testConst(3, 4);
	printf(77777);
	printf(888888);

	func3(2, 8, 100);
	a = func3(100, 2, 8);
	printf(a);
	
	printf(f(3, 4, 1));
	printf(fact(10));
	printf(fib(13));


	return 0;
}
