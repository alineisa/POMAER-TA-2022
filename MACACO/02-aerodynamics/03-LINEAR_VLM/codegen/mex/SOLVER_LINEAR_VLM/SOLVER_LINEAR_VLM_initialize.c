/*
 * SOLVER_LINEAR_VLM_initialize.c
 *
 * Code generation for function 'SOLVER_LINEAR_VLM_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "SOLVER_LINEAR_VLM.h"
#include "SOLVER_LINEAR_VLM_initialize.h"
#include "_coder_SOLVER_LINEAR_VLM_mex.h"
#include "SOLVER_LINEAR_VLM_data.h"

/* Function Definitions */
void SOLVER_LINEAR_VLM_initialize(void)
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

/* End of code generation (SOLVER_LINEAR_VLM_initialize.c) */
