/*
 * colon.c
 *
 * Code generation for function 'colon'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "SOLVER_LINEAR_VLM.h"
#include "colon.h"
#include "SOLVER_LINEAR_VLM_emxutil.h"
#include "eml_int_forloop_overflow_check.h"
#include "SOLVER_LINEAR_VLM_data.h"

/* Variable Definitions */
static emlrtRSInfo mb_emlrtRSI = { 149,/* lineNo */
  "colon",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\lib\\matlab\\ops\\colon.m"/* pathName */
};

static emlrtRTEInfo g_emlrtRTEI = { 139,/* lineNo */
  14,                                  /* colNo */
  "colon",                             /* fName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\lib\\matlab\\ops\\colon.m"/* pName */
};

/* Function Definitions */
void eml_signed_integer_colon(const emlrtStack *sp, int32_T b, emxArray_int32_T *
  y)
{
  int32_T n;
  int32_T yk;
  int32_T k;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if (b < 1) {
    n = 0;
  } else {
    n = b;
  }

  yk = y->size[0] * y->size[1];
  y->size[0] = 1;
  y->size[1] = n;
  emxEnsureCapacity(sp, (emxArray__common *)y, yk, sizeof(int32_T), &g_emlrtRTEI);
  if (n > 0) {
    y->data[0] = 1;
    yk = 1;
    st.site = &mb_emlrtRSI;
    if ((!(2 > n)) && (n > 2147483646)) {
      b_st.site = &k_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (k = 2; k <= n; k++) {
      yk++;
      y->data[k - 1] = yk;
    }
  }
}

/* End of code generation (colon.c) */
