/*
 * _coder_SOLVER_LINEAR_VLM_mex.c
 *
 * Code generation for function '_coder_SOLVER_LINEAR_VLM_mex'
 *
 */

/* Include files */
#include "SOLVER_LINEAR_VLM.h"
#include "_coder_SOLVER_LINEAR_VLM_mex.h"
#include "SOLVER_LINEAR_VLM_terminate.h"
#include "_coder_SOLVER_LINEAR_VLM_api.h"
#include "SOLVER_LINEAR_VLM_initialize.h"
#include "SOLVER_LINEAR_VLM_data.h"

/* Function Declarations */
static void SOLVER_LINEAR_VLM_mexFunction(int32_T nlhs, mxArray *plhs[2],
  int32_T nrhs, const mxArray *prhs[10]);

/* Function Definitions */
static void SOLVER_LINEAR_VLM_mexFunction(int32_T nlhs, mxArray *plhs[2],
  int32_T nrhs, const mxArray *prhs[10])
{
  int32_T n;
  const mxArray *inputs[10];
  const mxArray *outputs[2];
  int32_T b_nlhs;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 10) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 10, 4,
                        17, "SOLVER_LINEAR_VLM");
  }

  if (nlhs > 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 17,
                        "SOLVER_LINEAR_VLM");
  }

  /* Temporary copy for mex inputs. */
  for (n = 0; n < nrhs; n++) {
    inputs[n] = prhs[n];
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(&st);
    }
  }

  /* Call the function. */
  SOLVER_LINEAR_VLM_api(inputs, outputs);

  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }

  emlrtReturnArrays(b_nlhs, plhs, outputs);

  /* Module termination. */
  SOLVER_LINEAR_VLM_terminate();
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(SOLVER_LINEAR_VLM_atexit);

  /* Initialize the memory manager. */
  /* Module initialization. */
  SOLVER_LINEAR_VLM_initialize();

  /* Dispatch the entry-point. */
  SOLVER_LINEAR_VLM_mexFunction(nlhs, plhs, nrhs, prhs);
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_SOLVER_LINEAR_VLM_mex.c) */
