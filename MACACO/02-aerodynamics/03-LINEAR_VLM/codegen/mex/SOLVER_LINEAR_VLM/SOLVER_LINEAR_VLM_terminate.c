/*
 * SOLVER_LINEAR_VLM_terminate.c
 *
 * Code generation for function 'SOLVER_LINEAR_VLM_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "SOLVER_LINEAR_VLM.h"
#include "SOLVER_LINEAR_VLM_terminate.h"
#include "_coder_SOLVER_LINEAR_VLM_mex.h"
#include "SOLVER_LINEAR_VLM_data.h"

/* Function Definitions */
void SOLVER_LINEAR_VLM_atexit(void)
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

void SOLVER_LINEAR_VLM_terminate(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (SOLVER_LINEAR_VLM_terminate.c) */
