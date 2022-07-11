/*
 * VORTEX_INDUCED_terminate.c
 *
 * Code generation for function 'VORTEX_INDUCED_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "VORTEX_INDUCED.h"
#include "VORTEX_INDUCED_terminate.h"
#include "_coder_VORTEX_INDUCED_mex.h"
#include "VORTEX_INDUCED_data.h"

/* Function Definitions */
void VORTEX_INDUCED_atexit(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void VORTEX_INDUCED_terminate(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (VORTEX_INDUCED_terminate.c) */
