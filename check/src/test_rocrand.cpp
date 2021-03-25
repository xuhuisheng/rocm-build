#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <hip/hip_runtime.h>
#include <rocrand/rocrand.h>

int main()
{
	int N = 1024;
	rocrand_generator gen;
	float *p_d, *p_h;

	p_h = (float *) malloc(N * sizeof(float));

	hipMalloc((void **) &p_d, N * sizeof(float));

	rocrand_create_generator(&gen, ROCRAND_RNG_PSEUDO_MRG32K3A);

	rocrand_set_seed(gen, 11ULL);

	rocrand_generate_uniform(gen, p_d, N);

	hipMemcpy(p_h, p_d, N*sizeof(float), hipMemcpyDeviceToHost);

	for(int i = 0; i< N; i++){
		printf("%d, %.4f\n",i, p_h[i]);
	}

	rocrand_destroy_generator(gen);
	hipFree(p_d);
	free(p_h);
}


