/* 2351520 计拔 毛星博 */
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>

struct student {
	int no;			//学号，不考虑 0 开头 
	char name[9];   //姓名，最长 4 个汉字（无生僻字，均为双字节 GB 汉字） 
	int score;		//成绩，不考虑小数点 
	int rank;		//名次 
};

int main()
{
	int n;
	struct student *p;
	FILE *infile;

	infile = fopen("student.txt", "r");
	if (infile == NULL) {
		printf("文件打开失败\n");
		return -1;
	}

	fscanf(infile, "%d", &n);
	p = (struct student*)malloc(n * sizeof(struct student));

	if (p == NULL) {
		printf("内存分配失败\n");
		fclose(infile);
		return -1;
	}

	for (int i = 0; i < n; i++) {
		fscanf(infile, "%d %s %d", &p[i].no, p[i].name, &p[i].score);
	}

	fclose(infile);

	//先按成绩冒泡排序
	for (int i = 0; i < n - 1; i++) {
		for (int j = 0; j < n - i - 1; j++) {
			if (p[j].score < p[j + 1].score) {
				struct student temp = p[j];
				p[j] = p[j + 1];
				p[j + 1] = temp;
			}
		}	
	}

	//赋值名次
	p[0].rank = 1;
	for (int i = 1; i < n; i++) {
		if (p[i].score == p[i - 1].score) {
			p[i].rank = p[i - 1].rank;
		}
		else {
			p[i].rank = i + 1;
		}
	}

	//再按学号冒泡排序
	for (int i = 0; i < n - 1; i++) {
		for (int j = 0; j < n - i - 1; j++) {
			if (p[j].no > p[j + 1].no) {
				struct student temp = p[j];
				p[j] = p[j + 1];
				p[j + 1] = temp;
			}
		}
	}

	//输出结果
	for (int i = 0; i < n; i++) {
		printf("%d %s %d %d\n", p[i].no, p[i].name, p[i].score, p[i].rank);
	}

	free(p);
	return 0;
}