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

int main() {
	printf(77777);
	func();
	printf(888888);

	return 0;
}
