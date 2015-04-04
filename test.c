/*int f(int p1, int p2, int p3) {
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

int testPointer() {
	int val1 = 3;
	int val2 = 4;
	int *p1 = &val1;
	int **p2 = &p1;

	printf(val1);
	printf(val2);

	printf(p1);
	printf(*p1);

	printf(p2);
	printf(*p2);
	printf(**p2);

	printf(8888888);

	*p1 = 7;
	printf(val1);
	printf(val2);

	printf(p1);
	printf(*p1);

	printf(p2);
	printf(*p2);
	printf(**p2);

	printf(8888888);

	**p2 = 8;
	printf(val1);
	printf(val2);

	printf(p1);
	printf(*p1);

	printf(p2);
	printf(*p2);
	printf(**p2);

	printf(14141414);

	val2 = 14;
	printf(val1);
	printf(val2);

	printf(p1);
	printf(*p1);

	printf(p2);
	printf(*p2);
	printf(**p2);

	printf(15151515);

	*p2 = &val2;
	printf(val1);
	printf(val2);

	printf(p1);
	printf(*p1);

	printf(p2);
	printf(*p2);
	printf(**p2);

	return 0;
}*/

/*int triple(int *param) {
	*param *= 3;

	return 0;
}

int doubleParams(int *a, int *b);*/

/*int *max(int *a, int *b) {
	doubleParams(a, b);
	if(*b < *a) {
		return a;
	}

	return b;
}

void fVoid() {
	printf(444);
}*/

void printTruc() {
	printf("truc\n");
}

int main() {
	char const *a = "abcdefgh\n";
	char const *c = "abcdefghi";
	char const *b = "abcdefgh";

	char const *truc = "truc\n";

	printTruc();

	printf(a);
	printf(b);
	printf(c);

	printf(truc);

	/*int tab[4] = {5, 4, 3, 1};

	int i = 42, j = 77;

	int *p = &i;

	doubleParams(&i, &j);


	for(int i = 0; i < 4; ++i) {
		int tt = tab[i];
		printf(tt);
		printf(" ");
		printf(tt);
		printf("\n");
	}

	printf(*p);
	printf(" ");
	printf(j);
	printf("\n");*/



	/*void *varVoid;
	int i = 4, j, a = 3, c, d, res;
	int *p1 = &c, p2 = &d;

	testPointer();

	res = 0;
	for(j = 0; j < 20; ++j) {
		for(i = 0; i < 100; ++i) {
			res += i;
		}
	}
	printf(res);

	testPointer();
	testConst(3, 4);
	printf(77777);
	printf(888888);

	func3(2, 8, 100);
	a = func3(100, 2, 8);
	printf(a);
	
	printf(f(3, 4, 1));
	printf(fact(10));
	printf(fib(13));

	c = 42, d = 34;

	printf(c);
	printf(d);
	doubleParams(&c, &d);
	printf(c);
	printf(d);

	p1 = max(&c, &d);
	printf(c);
	printf(d);
	printf(*p1);

	fVoid();
	printf(3.55E4);

	varVoid = NULL;

	return 0;

	;*/


	return 0;
}

/*int doubleParams(int *a, int *b) {
	*a *= 2;
	triple(a);
	*b *= 2;

	return 0;
}*/
