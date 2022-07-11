/*
 * error.c
 *
 * Code generation for function 'error'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "SOLVER_LINEAR_VLM.h"
#include "error.h"

/* Variable Definitions */
static emlrtRTEInfo s_emlrtRTEI = { 17,/* lineNo */
  9,                                   /* colNo */
  "error",                             /* fName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\error.m"/* pName */
};

/* Function Definitions */
void b_error(const emlrtStack *sp)
{
  emlrtErrorWithMessageIdR2012b(sp, &s_emlrtRTEI, "MATLAB:nomem", 0);
}

void c_error(const emlrtStack *sp, int32_T varargin_2)
{
  emlrtErrorWithMessageIdR2012b(sp, &s_emlrtRTEI,
    "Coder:toolbox:LAPACKCallErrorInfo", 5, 4, 14, "LAPACKE_dgeqp3", 12,
    varargin_2);
}

void d_error(const emlrtStack *sp, int32_T varargin_2)
{
  emlrtErrorWithMessageIdR2012b(sp, &s_emlrtRTEI,
    "Coder:toolbox:LAPACKCallErrorInfo", 5, 4, 14, "LAPACKE_dormqr", 12,
    varargin_2);
}

void e_error(const emlrtStack *sp, int32_T varargin_2)
{
  emlrtErrorWithMessageIdR2012b(sp, &s_emlrtRTEI,
    "Coder:toolbox:LAPACKCallErrorInfo", 5, 4, 19, "LAPACKE_dgetrf_work", 12,
    varargin_2);
}

void error(const emlrtStack *sp)
{
  emlrtErrorWithMessageIdR2012b(sp, &s_emlrtRTEI, "MATLAB:nologicalnan", 0);
}

/* End of code generation (error.c) */
