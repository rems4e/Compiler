int main { 
	/*if(0) {
		printf(88888888);
		if(1) {
			printf(6666666);
		}
		else {
			printf(7777777);
		}
		printf(5555555);
	}
	else {
		printf(4444444);
	}*/

	int i = 0;
	int j = 100;

	while(j > 0) {
		i = i + 1;
		j = j - 1;
		printf(i);
		printf(j);
		if(i > 20) {
			printf(88888888);
			if(i > 40) {
				printf(6666666);
			}
			else {
				printf(7777777);
			}
			printf(5555555);
		}
		printf(99999999);
	}
	printf(99999999);
	printf(99999999);
	printf(i);
	printf(j);

	return 0;
}
