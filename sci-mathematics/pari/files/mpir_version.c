#include <stdio.h>
#include <mpir.h>
void f(void) { mpn_gcdext(NULL,NULL, NULL, NULL, 0, NULL, 0); }
main(){ printf("%s", mpir_version); }
