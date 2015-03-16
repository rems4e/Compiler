int f(int p1, int p2) {
	printf(1000 * p1 + p2);
	return 0;
}

int func3(int a, int b, int d) {
	int c = d * a + b;
	printf(c);
	f(b, a);
	return 0;
}
/*int func2() {
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
}*/

int main() {
	/*printf(77777);*/
	//func();
	printf(888888);

	func3(2, 8, 100);
	func3(100, 2, 8);

	return 0;
}
