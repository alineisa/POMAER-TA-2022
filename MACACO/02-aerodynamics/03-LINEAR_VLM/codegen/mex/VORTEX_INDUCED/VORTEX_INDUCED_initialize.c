/*
 * VORTEX_INDUCED_initialize.c
 *
 * Code generation for function 'VORTEX_INDUCED_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "VORTEX_INDUCED.h"
#include "VORTEX_INDUCED_initialize.h"
#include "_coder_VORTEX_INDUCED_mex.h"
#include "VORTEX_INDUCED_data.h"

/* Function Definitions */
void VORTEX_INDUCED_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (VORTEX_INDUCED_initialize.c) */
