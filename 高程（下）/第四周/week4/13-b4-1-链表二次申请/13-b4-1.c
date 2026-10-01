/* 2351520 计拔 毛星博 */
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>

struct student {
	int* no; //学号，不考虑 0 开头 
	char* name; //姓名，无生僻字，均为双字节 GB 汉字 
	int* score; //成绩，不考虑小数点 
	struct student* next;
};

int main()
{
	struct student* p, * head, * q;
	FILE* infile;

	infile = fopen("list.txt", "r");
	if (infile == NULL) {
		printf("文件打开失败\n");
		return -1;
	}

	head = NULL;
	p = NULL;

	while (1) {
		q = (struct student*)malloc(sizeof(struct student));
		if (q == NULL) {
			printf("内存分配失败\n");
			return -1;
		}

		q->no = (int*)malloc(sizeof(int));
		q->name = (char*)malloc(sizeof(char) * 9);
		q->score = (int*)malloc(sizeof(int));

		fscanf(infile, "%d %s %d", q->no, q->name, q->score);
		if (*(q->no) == 9999999) {
			free(q->no);
			free(q->name);
			free(q->score);
			free(q);
			break;
		}

		q->next = NULL;

		if (head == NULL) {
			head = q;
		}
		else {
			p->next = q;
		}
		p = q;
	}

	fclose(infile);

	p = head;
	while (p != NULL) {
		printf("%d %-8s %3d\n", *(p->no), p->name, *(p->score));
		q = p;
		p = p->next;
		free(q->no);
		free(q->name);
		free(q->score);
		free(q);
	}

	return 0;
}