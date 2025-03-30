/*
 * source.c
 *
 *  Created on: Mar 28, 2025
 *      Author: cute
 */

#include <io.h>
#include <system.h>
#include <stdio.h>

int main()
{
	int A, B, Z;

	A = 5;
	B = 7;

	IOWR(AVALON_ARRAY_MULTIPLIER_0_BASE, 0, A);
	IOWR(AVALON_ARRAY_MULTIPLIER_0_BASE, 1, B);

	Z = IORD(AVALON_ARRAY_MULTIPLIER_0_BASE, 2);

	printf("Ket qua = %d\n",Z);
}
