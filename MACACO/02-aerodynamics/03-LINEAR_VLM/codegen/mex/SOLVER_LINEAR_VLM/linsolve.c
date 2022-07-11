/*
 * linsolve.c
 *
 * Code generation for function 'linsolve'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "SOLVER_LINEAR_VLM.h"
#include "linsolve.h"
#include "SOLVER_LINEAR_VLM_emxutil.h"
#include "qrsolve.h"
#include "warning.h"
#include "xgetrf.h"
#include "blas.h"

/* Variable Definitions */
static emlrtRSInfo t_emlrtRSI = { 215, /* lineNo */
  "linsolve",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\lib\\matlab\\matfun\\linsolve.m"/* pathName */
};

static emlrtRSInfo u_emlrtRSI = { 231, /* lineNo */
  "linsolve",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\lib\\matlab\\matfun\\linsolve.m"/* pathName */
};

static emlrtRSInfo ec_emlrtRSI = { 42, /* lineNo */
  "lusolve",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\lusolve.m"/* pathName */
};

static emlrtRSInfo fc_emlrtRSI = { 102,/* lineNo */
  "lusolve",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\lusolve.m"/* pathName */
};

static emlrtRSInfo gc_emlrtRSI = { 100,/* lineNo */
  "lusolve",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\lusolve.m"/* pathName */
};

static emlrtRSInfo hc_emlrtRSI = { 132,/* lineNo */
  "lusolve",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\lusolve.m"/* pathName */
};

static emlrtRSInfo ic_emlrtRSI = { 143,/* lineNo */
  "lusolve",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\lusolve.m"/* pathName */
};

static emlrtRSInfo jc_emlrtRSI = { 145,/* lineNo */
  "lusolve",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\lusolve.m"/* pathName */
};

static emlrtRSInfo sc_emlrtRSI = { 76, /* lineNo */
  "lusolve",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\lusolve.m"/* pathName */
};

static emlrtRTEInfo d_emlrtRTEI = { 1, /* lineNo */
  18,                                  /* colNo */
  "linsolve",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\lib\\matlab\\matfun\\linsolve.m"/* pName */
};

static emlrtRTEInfo t_emlrtRTEI = { 93,/* lineNo */
  15,                                  /* colNo */
  "linsolve",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\lib\\matlab\\matfun\\linsolve.m"/* pName */
};

static emlrtRTEInfo u_emlrtRTEI = { 219,/* lineNo */
  23,                                  /* colNo */
  "linsolve",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\lib\\matlab\\matfun\\linsolve.m"/* pName */
};

/* Function Definitions */
void linsolve(const emlrtStack *sp, const emxArray_real_T *A, emxArray_real_T *B)
{
  boolean_T b0;
  emxArray_real_T *b_A;
  int32_T info;
  int32_T loop_ub;
  emxArray_int32_T *ipiv;
  real_T temp;
  char_T DIAGA;
  char_T TRANSA;
  char_T UPLO;
  char_T SIDE;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t ldb_t;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  b0 = (A->size[0] == B->size[0]);
  if (!b0) {
    emlrtErrorWithMessageIdR2012b(sp, &t_emlrtRTEI, "MATLAB:dimagree", 0);
  }

  if (A->size[0] != A->size[1]) {
    emxInit_real_T2(sp, &b_A, 1, &d_emlrtRTEI, true);
    info = b_A->size[0];
    b_A->size[0] = B->size[0];
    emxEnsureCapacity(sp, (emxArray__common *)b_A, info, sizeof(real_T),
                      &d_emlrtRTEI);
    loop_ub = B->size[0];
    for (info = 0; info < loop_ub; info++) {
      b_A->data[info] = B->data[info];
    }

    st.site = &t_emlrtRSI;
    qrsolve(&st, A, b_A, B, &info);
    emxFree_real_T(&b_A);
  } else {
    if (A->size[0] != A->size[1]) {
      emlrtErrorWithMessageIdR2012b(sp, &u_emlrtRTEI, "MATLAB:square", 0);
    }

    emxInit_real_T1(sp, &b_A, 2, &d_emlrtRTEI, true);
    st.site = &u_emlrtRSI;
    b_st.site = &ec_emlrtRSI;
    info = b_A->size[0] * b_A->size[1];
    b_A->size[0] = A->size[0];
    b_A->size[1] = A->size[1];
    emxEnsureCapacity(&b_st, (emxArray__common *)b_A, info, sizeof(real_T),
                      &d_emlrtRTEI);
    loop_ub = A->size[0] * A->size[1];
    for (info = 0; info < loop_ub; info++) {
      b_A->data[info] = A->data[info];
    }

    emxInit_int32_T1(&b_st, &ipiv, 2, &d_emlrtRTEI, true);
    c_st.site = &gc_emlrtRSI;
    xgetrf(&c_st, A->size[1], A->size[1], b_A, A->size[1], ipiv, &info);
    if (info > 0) {
      c_st.site = &fc_emlrtRSI;
      d_st.site = &sc_emlrtRSI;
      b_warning(&d_st);
    }

    c_st.site = &hc_emlrtRSI;
    for (info = 0; info + 1 < A->size[1]; info++) {
      if (ipiv->data[info] != info + 1) {
        temp = B->data[info];
        B->data[info] = B->data[ipiv->data[info] - 1];
        B->data[ipiv->data[info] - 1] = temp;
      }
    }

    emxFree_int32_T(&ipiv);
    c_st.site = &ic_emlrtRSI;
    if (!(A->size[1] < 1)) {
      temp = 1.0;
      DIAGA = 'U';
      TRANSA = 'N';
      UPLO = 'L';
      SIDE = 'L';
      m_t = (ptrdiff_t)A->size[1];
      n_t = (ptrdiff_t)1;
      lda_t = (ptrdiff_t)A->size[1];
      ldb_t = (ptrdiff_t)A->size[1];
      dtrsm(&SIDE, &UPLO, &TRANSA, &DIAGA, &m_t, &n_t, &temp, &b_A->data[0],
            &lda_t, &B->data[0], &ldb_t);
    }

    c_st.site = &jc_emlrtRSI;
    if (!(A->size[1] < 1)) {
      temp = 1.0;
      DIAGA = 'N';
      TRANSA = 'N';
      UPLO = 'U';
      SIDE = 'L';
      m_t = (ptrdiff_t)A->size[1];
      n_t = (ptrdiff_t)1;
      lda_t = (ptrdiff_t)A->size[1];
      ldb_t = (ptrdiff_t)A->size[1];
      dtrsm(&SIDE, &UPLO, &TRANSA, &DIAGA, &m_t, &n_t, &temp, &b_A->data[0],
            &lda_t, &B->data[0], &ldb_t);
    }

    emxFree_real_T(&b_A);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (linsolve.c) */
