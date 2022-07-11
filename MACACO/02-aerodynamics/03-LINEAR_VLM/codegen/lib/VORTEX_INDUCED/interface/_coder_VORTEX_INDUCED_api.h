/*
 * File: _coder_VORTEX_INDUCED_api.h
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 19-Aug-2018 14:58:07
 */

#ifndef _CODER_VORTEX_INDUCED_API_H
#define _CODER_VORTEX_INDUCED_API_H

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_VORTEX_INDUCED_api.h"

/* Type Definitions */
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T

struct emxArray_real_T
{
  real_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_real_T*/

#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T

typedef struct emxArray_real_T emxArray_real_T;

#endif                                 /*typedef_emxArray_real_T*/

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void VORTEX_INDUCED(real_T P[3], emxArray_real_T *Vortex, real_T G,
  real_T tipo, real_T Vind[3]);
extern void VORTEX_INDUCED_api(const mxArray * const prhs[4], const mxArray
  *plhs[1]);
extern void VORTEX_INDUCED_atexit(void);
extern void VORTEX_INDUCED_initialize(void);
extern void VORTEX_INDUCED_terminate(void);
extern void VORTEX_INDUCED_xil_terminate(void);

#endif

/*
 * File trailer for _coder_VORTEX_INDUCED_api.h
 *
 * [EOF]
 */
