/* 2351520 计拔 毛星博 */
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <math.h>

double definite_integration(double(*f)(double), double low, double high, int n)
{
	double h = (high - low) / n;
	double sum = 0.0;
	for (int i = 0; i < n; i++)
	{
		sum += f(low + (i + 1) * h);
	}
	return h * sum;
}

int main()
{
	int n;
	double low, high, value;

	printf("请输入sinxdx的下限、上限及区间划分数量\n");
	scanf("%lf%lf%d", &low, &high, &n);
	value = definite_integration(sin, low, high, n);
	printf("sinxdx[%g~%g/n=%d] : %g\n", low, high, n, value);

	printf("请输入cosxdx的下限、上限及区间划分数量\n");
	scanf("%lf%lf%d", &low, &high, &n);
	value = definite_integration(cos, low, high, n);
	printf("cosxdx[%g~%g/n=%d] : %g\n", low, high, n, value);

	printf("请输入e^xdx的下限、上限及区间划分数量\n");
	scanf("%lf%lf%d", &low, &high, &n);
	value = definite_integration(exp, low, high, n);
	printf("e^xdx[%g~%g/n=%d] : %g\n", low, high, n, value);

	return 0;
}
