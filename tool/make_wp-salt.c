
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <string.h>

#include "seed.h"

#define	SALT_NUM	(8)

#define SALT_NAME1	("AUTH_KEY")
#define SALT_NAME2	("SECURE_AUTH_KEY")
#define SALT_NAME3	("LOGGED_IN_KEY")
#define SALT_NAME4	("NONCE_KEY")
#define SALT_NAME5	("AUTH_SALT")
#define SALT_NAME6	("SECURE_AUTH_SALT")
#define SALT_NAME7	("LOGGED_IN_SALT")
#define SALT_NAME8	("NONCE_SALT")



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
	char key[SALT_NUM][SEED_LEN];
	char *ptr;

	char *salt_name[SALT_NUM]={ SALT_NAME1,
                                    SALT_NAME2,
                                    SALT_NAME3,
                                    SALT_NAME4,
                                    SALT_NAME5,
                                    SALT_NAME6,
                                    SALT_NAME7,
                                    SALT_NAME8 };

	pid = getpid();
#ifdef _USE_RANDOM
	srandom((int)time(&t) + pid);
#else
	srand((int)time(&t) + pid);
#endif


/*
	if (argc < 2)
	{
		fprintf(stdout, "usage: %s [count]\n", argv[0]);
		exit (-1);
	}
*/

	ptr = &key[0][0];
	num = SALT_NUM;
	for (i = 0; i < num; i++)
	{
		memset(key[i], _NULL, SEED_LEN);
		rndSeed(key[i], SEED_LEN);

		fprintf(stdout, "define(\'%s\',\'%s\');\n", salt_name[i], key[i]);	
	}

/*
define('AUTH_KEY',         'put your unique phrase here');

 */

	return (1);
}

