
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

void doubleParam(int *a);

enum {TabSize = 5};

int main() {
	int values[TabSize] = {0};
	print("Veuillez entrer ");
 	print(TabSize);
	print(" valeurs :\n");
	for(int i = 0; i < TabSize; ++i) {
		print(i);
		print(" : ");
		scan(values + i);
	}

	print("Après traitement :\n");
	for(int i = 0; i < TabSize; ++i) {
		values[i] = fib(values[i]);
		doubleParam(values + i);
		print(values[i]);
		print('\n');
	}

	return 0;
}

void doubleParam(int *p) {
	*p *= 2;
}
