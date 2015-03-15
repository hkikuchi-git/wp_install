
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <string.h>

#include "seed.h"



int getNum(int num)
{
	int res;
	
#ifdef _USE_RANDOM
	res = random() % num;
#else
	res = rand() % num;
#endif

	return(res);
}


int rndSeed(char *str, int len)
{
	int r1, r2;
	int i;
	char s1[] = RND_SEED1;
	char s2[] = RND_SEED2;
	char s3[] = RND_NUM;
/*	char s4[] = RND_KEY; */

	for (i = 0; i < len; i++)
	{
		r1 = getNum(3);

		switch (r1)
		{
		case 0:
			r2 = getNum(strlen(s1));
			str[i] = s1[r2];
			break;
		case 1:
			r2 = getNum(strlen(s2));
			str[i] = s2[r2];
			break;
		case 2:
			r2 = getNum(strlen(s3));
			str[i] = s3[r2];
			break;
/*
		case 3:
			r2 = getNum(strlen(s4));
			str[i] = s4[r2];
			break;
*/
		}
	}
	str[len] = '\0';
	return (0);
}

int main(int argc, char *argv[])
{
	int i;
	int num;
	time_t t;
	pid_t pid;
	char key[SEED_LEN];

	pid = getpid();
#ifdef _USE_RANDOM
	srandom((int)time(&t) + pid);
#else
	srand((int)time(&t) + pid);
#endif

	memset(key, _NULL, SEED_LEN);

	if (argc < 2)
	{
		fprintf(stdout, "usage: %s [count]\n", argv[0]);
		exit (-1);
	}

	num = atoi(argv[1]);
	for (i = 0; i < num; i++)
	{
		rndSeed(key, SEED_LEN);
		fprintf(stdout, "%s\n", key);	
	}
	return (1);
}

