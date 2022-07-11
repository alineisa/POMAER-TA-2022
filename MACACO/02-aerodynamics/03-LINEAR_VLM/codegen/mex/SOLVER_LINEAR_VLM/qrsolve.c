/*
 * qrsolve.c
 *
 * Code generation for function 'qrsolve'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "SOLVER_LINEAR_VLM.h"
#include "qrsolve.h"
#include "SOLVER_LINEAR_VLM_emxutil.h"
#include "error.h"
#include "eml_int_forloop_overflow_check.h"
#include "warning.h"
#include "xgeqp3.h"
#include "SOLVER_LINEAR_VLM_data.h"
#include "lapacke.h"

/* Variable Definitions */
static emlrtRSInfo v_emlrtRSI = { 28,  /* lineNo */
  "qrsolve",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\qrsolve.m"/* pathName */
};

static emlrtRSInfo w_emlrtRSI = { 32,  /* lineNo */
  "qrsolve",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\qrsolve.m"/* pathName */
};

static emlrtRSInfo x_emlrtRSI = { 39,  /* lineNo */
  "qrsolve",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\qrsolve.m"/* pathName */
};

static emlrtRSInfo sb_emlrtRSI = { 121,/* lineNo */
  "qrsolve",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\qrsolve.m"/* pathName */
};

static emlrtRSInfo tb_emlrtRSI = { 120,/* lineNo */
  "qrsolve",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\qrsolve.m"/* pathName */
};

static emlrtRSInfo ub_emlrtRSI = { 72, /* lineNo */
  "qrsolve",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\qrsolve.m"/* pathName */
};

static emlrtRSInfo vb_emlrtRSI = { 79, /* lineNo */
  "qrsolve",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\qrsolve.m"/* pathName */
};

static emlrtRSInfo wb_emlrtRSI = { 89, /* lineNo */
  "qrsolve",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\qrsolve.m"/* pathName */
};

static emlrtRSInfo xb_emlrtRSI = { 29, /* lineNo */
  "xunormqr",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xunormqr.m"/* pathName */
};

static emlrtRSInfo yb_emlrtRSI = { 101,/* lineNo */
  "xunormqr",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xunormqr.m"/* pathName */
};

static emlrtRSInfo ac_emlrtRSI = { 91, /* lineNo */
  "xunormqr",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xunormqr.m"/* pathName */
};

static emlrtRSInfo bc_emlrtRSI = { 78, /* lineNo */
  "xunormqr",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xunormqr.m"/* pathName */
};

static emlrtRSInfo cc_emlrtRSI = { 77, /* lineNo */
  "xunormqr",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xunormqr.m"/* pathName */
};

static emlrtRSInfo dc_emlrtRSI = { 57, /* lineNo */
  "xunormqr",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xunormqr.m"/* pathName */
};

static emlrtMCInfo emlrtMCI = { 52,    /* lineNo */
  19,                                  /* colNo */
  "flt2str",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\flt2str.m"/* pName */
};

static emlrtRTEInfo e_emlrtRTEI = { 1, /* lineNo */
  24,                                  /* colNo */
  "qrsolve",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\qrsolve.m"/* pName */
};

static emlrtRSInfo xc_emlrtRSI = { 52, /* lineNo */
  "flt2str",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\flt2str.m"/* pathName */
};

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, char_T y[14]);
static const mxArray *b_sprintf(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, emlrtMCInfo *location);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *c_sprintf,
  const char_T *identifier, char_T y[14]);
static void k_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, char_T ret[14]);

/* Function Definitions */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, char_T y[14])
{
  k_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static const mxArray *b_sprintf(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, emlrtMCInfo *location)
{
  const mxArray *pArrays[2];
  const mxArray *m5;
  pArrays[0] = b;
  pArrays[1] = c;
  return emlrtCallMATLABR2012b(sp, 1, &m5, 2, pArrays, "sprintf", true, location);
}

static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *c_sprintf,
  const char_T *identifier, char_T y[14])
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  b_emlrt_marshallIn(sp, emlrtAlias(c_sprintf), &thisId, y);
  emlrtDestroyArray(&c_sprintf);
}

static void k_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, char_T ret[14])
{
  static const int32_T dims[2] = { 1, 14 };

  emlrtCheckBuiltInR2012b(sp, msgId, src, "char", false, 2U, dims);
  emlrtImportCharArrayR2015b(sp, src, ret, 14);
  emlrtDestroyArray(&src);
}

void qrsolve(const emlrtStack *sp, const emxArray_real_T *A, const
             emxArray_real_T *B, emxArray_real_T *Y, int32_T *rankR)
{
  emxArray_real_T *b_A;
  int32_T maxmn;
  int32_T minmn;
  emxArray_real_T *tau;
  emxArray_int32_T *jpvt;
  int32_T b_rankR;
  real_T tol;
  emxArray_real_T *b_B;
  const mxArray *y;
  const mxArray *m0;
  static const int32_T iv1[2] = { 1, 6 };

  static const char_T rfmt[6] = { '%', '1', '4', '.', '6', 'e' };

  const mxArray *b_y;
  char_T cv0[14];
  ptrdiff_t nrc_t;
  ptrdiff_t info_t;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  emxInit_real_T1(sp, &b_A, 2, &e_emlrtRTEI, true);
  maxmn = b_A->size[0] * b_A->size[1];
  b_A->size[0] = A->size[0];
  b_A->size[1] = A->size[1];
  emxEnsureCapacity(sp, (emxArray__common *)b_A, maxmn, sizeof(real_T),
                    &e_emlrtRTEI);
  minmn = A->size[0] * A->size[1];
  for (maxmn = 0; maxmn < minmn; maxmn++) {
    b_A->data[maxmn] = A->data[maxmn];
  }

  emxInit_real_T2(sp, &tau, 1, &e_emlrtRTEI, true);
  emxInit_int32_T1(sp, &jpvt, 2, &e_emlrtRTEI, true);
  st.site = &v_emlrtRSI;
  xgeqp3(&st, b_A, tau, jpvt);
  st.site = &w_emlrtRSI;
  b_rankR = 0;
  tol = 0.0;
  if (b_A->size[0] < b_A->size[1]) {
    minmn = b_A->size[0];
    maxmn = b_A->size[1];
  } else {
    minmn = b_A->size[1];
    maxmn = b_A->size[0];
  }

  if (minmn > 0) {
    tol = (real_T)maxmn * muDoubleScalarAbs(b_A->data[0]) *
      2.2204460492503131E-16;
    while ((b_rankR < minmn) && (muDoubleScalarAbs(b_A->data[b_rankR + b_A->
             size[0] * b_rankR]) >= tol)) {
      b_rankR++;
    }
  }

  if (b_rankR < minmn) {
    b_st.site = &sb_emlrtRSI;
    y = NULL;
    m0 = emlrtCreateCharArray(2, iv1);
    emlrtInitCharArrayR2013a(&b_st, 6, m0, &rfmt[0]);
    emlrtAssign(&y, m0);
    b_y = NULL;
    m0 = emlrtCreateDoubleScalar(tol);
    emlrtAssign(&b_y, m0);
    c_st.site = &xc_emlrtRSI;
    emlrt_marshallIn(&c_st, b_sprintf(&c_st, y, b_y, &emlrtMCI), "sprintf", cv0);
    b_st.site = &tb_emlrtRSI;
    warning(&b_st, b_rankR, cv0);
  }

  emxInit_real_T2(&st, &b_B, 1, &e_emlrtRTEI, true);
  st.site = &x_emlrtRSI;
  maxmn = b_B->size[0];
  b_B->size[0] = B->size[0];
  emxEnsureCapacity(&st, (emxArray__common *)b_B, maxmn, sizeof(real_T),
                    &e_emlrtRTEI);
  minmn = B->size[0];
  for (maxmn = 0; maxmn < minmn; maxmn++) {
    b_B->data[maxmn] = B->data[maxmn];
  }

  minmn = b_A->size[1];
  maxmn = Y->size[0];
  Y->size[0] = minmn;
  emxEnsureCapacity(&st, (emxArray__common *)Y, maxmn, sizeof(real_T),
                    &e_emlrtRTEI);
  for (maxmn = 0; maxmn < minmn; maxmn++) {
    Y->data[maxmn] = 0.0;
  }

  b_st.site = &ub_emlrtRSI;
  c_st.site = &xb_emlrtRSI;
  minmn = muIntScalarMin_sint32(b_A->size[0], b_A->size[1]);
  d_st.site = &dc_emlrtRSI;
  if ((!((b_A->size[0] == 0) || (b_A->size[1] == 0))) && (!(b_B->size[0] == 0)))
  {
    d_st.site = &cc_emlrtRSI;
    d_st.site = &bc_emlrtRSI;
    nrc_t = (ptrdiff_t)b_B->size[0];
    d_st.site = &ac_emlrtRSI;
    info_t = LAPACKE_dormqr(102, 'L', 'T', nrc_t, (ptrdiff_t)1, (ptrdiff_t)minmn,
      &b_A->data[0], (ptrdiff_t)b_A->size[0], &tau->data[0], &b_B->data[0],
      nrc_t);
    minmn = (int32_T)info_t;
    d_st.site = &yb_emlrtRSI;
    if (minmn != 0) {
      if (minmn == -1010) {
        e_st.site = &pb_emlrtRSI;
        b_error(&e_st);
      } else {
        e_st.site = &qb_emlrtRSI;
        d_error(&e_st, minmn);
      }
    }
  }

  emxFree_real_T(&tau);
  b_st.site = &vb_emlrtRSI;
  if ((!(1 > b_rankR)) && (b_rankR > 2147483646)) {
    c_st.site = &k_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (minmn = 0; minmn + 1 <= b_rankR; minmn++) {
    Y->data[jpvt->data[minmn] - 1] = b_B->data[minmn];
  }

  emxFree_real_T(&b_B);
  for (maxmn = b_rankR - 1; maxmn + 1 > 0; maxmn--) {
    Y->data[jpvt->data[maxmn] - 1] /= b_A->data[maxmn + b_A->size[0] * maxmn];
    b_st.site = &wb_emlrtRSI;
    for (minmn = 0; minmn + 1 <= maxmn; minmn++) {
      Y->data[jpvt->data[minmn] - 1] -= Y->data[jpvt->data[maxmn] - 1] *
        b_A->data[minmn + b_A->size[0] * maxmn];
    }
  }

  emxFree_int32_T(&jpvt);
  emxFree_real_T(&b_A);
  *rankR = b_rankR;
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (qrsolve.c) */
