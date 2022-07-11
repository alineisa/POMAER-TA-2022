/*
 * xgeqp3.c
 *
 * Code generation for function 'xgeqp3'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "SOLVER_LINEAR_VLM.h"
#include "xgeqp3.h"
#include "SOLVER_LINEAR_VLM_emxutil.h"
#include "error.h"
#include "colon.h"
#include "SOLVER_LINEAR_VLM_data.h"
#include "lapacke.h"

/* Variable Definitions */
static emlrtRSInfo y_emlrtRSI = { 14,  /* lineNo */
  "xgeqp3",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo ab_emlrtRSI = { 37, /* lineNo */
  "xgeqp3",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo bb_emlrtRSI = { 38, /* lineNo */
  "xgeqp3",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo cb_emlrtRSI = { 41, /* lineNo */
  "xgeqp3",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo db_emlrtRSI = { 45, /* lineNo */
  "xgeqp3",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo eb_emlrtRSI = { 64, /* lineNo */
  "xgeqp3",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo fb_emlrtRSI = { 67, /* lineNo */
  "xgeqp3",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo gb_emlrtRSI = { 76, /* lineNo */
  "xgeqp3",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo hb_emlrtRSI = { 79, /* lineNo */
  "xgeqp3",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo ib_emlrtRSI = { 7,  /* lineNo */
  "int",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\int.m"/* pathName */
};

static emlrtRSInfo jb_emlrtRSI = { 25, /* lineNo */
  "colon",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\lib\\matlab\\ops\\colon.m"/* pathName */
};

static emlrtRSInfo kb_emlrtRSI = { 78, /* lineNo */
  "colon",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\lib\\matlab\\ops\\colon.m"/* pathName */
};

static emlrtRSInfo lb_emlrtRSI = { 121,/* lineNo */
  "colon",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\lib\\matlab\\ops\\colon.m"/* pathName */
};

static emlrtRSInfo nb_emlrtRSI = { 8,  /* lineNo */
  "majority",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\majority.m"/* pathName */
};

static emlrtRSInfo ob_emlrtRSI = { 31, /* lineNo */
  "infocheck",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\infocheck.m"/* pathName */
};

static emlrtRTEInfo f_emlrtRTEI = { 1, /* lineNo */
  25,                                  /* colNo */
  "xgeqp3",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pName */
};

static emlrtRTEInfo j_emlrtRTEI = { 45,/* lineNo */
  5,                                   /* colNo */
  "xgeqp3",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pName */
};

/* Function Definitions */
void xgeqp3(const emlrtStack *sp, emxArray_real_T *A, emxArray_real_T *tau,
            emxArray_int32_T *jpvt)
{
  int32_T m;
  int32_T n;
  emxArray_ptrdiff_t *jpvt_t;
  int32_T i2;
  ptrdiff_t m_t;
  ptrdiff_t info_t;
  boolean_T p;
  boolean_T b_p;
  int32_T loop_ub;
  int32_T i3;
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
  st.site = &y_emlrtRSI;
  m = A->size[0];
  n = A->size[1];
  b_st.site = &ab_emlrtRSI;
  c_st.site = &ib_emlrtRSI;
  b_st.site = &bb_emlrtRSI;
  if ((A->size[0] == 0) || (A->size[1] == 0)) {
    i2 = tau->size[0];
    tau->size[0] = 0;
    emxEnsureCapacity(&st, (emxArray__common *)tau, i2, sizeof(real_T),
                      &f_emlrtRTEI);
    b_st.site = &cb_emlrtRSI;
    c_st.site = &jb_emlrtRSI;
    d_st.site = &kb_emlrtRSI;
    e_st.site = &lb_emlrtRSI;
    eml_signed_integer_colon(&e_st, A->size[1], jpvt);
  } else {
    emxInit_ptrdiff_t(&st, &jpvt_t, 1, &j_emlrtRTEI, true);
    i2 = tau->size[0];
    tau->size[0] = muIntScalarMin_sint32(m, n);
    emxEnsureCapacity(&st, (emxArray__common *)tau, i2, sizeof(real_T),
                      &f_emlrtRTEI);
    b_st.site = &db_emlrtRSI;
    c_st.site = &ib_emlrtRSI;
    i2 = jpvt_t->size[0];
    jpvt_t->size[0] = A->size[1];
    emxEnsureCapacity(&st, (emxArray__common *)jpvt_t, i2, sizeof(ptrdiff_t),
                      &f_emlrtRTEI);
    m = A->size[1];
    for (i2 = 0; i2 < m; i2++) {
      jpvt_t->data[i2] = (ptrdiff_t)0;
    }

    b_st.site = &eb_emlrtRSI;
    c_st.site = &ib_emlrtRSI;
    m_t = (ptrdiff_t)A->size[0];
    b_st.site = &fb_emlrtRSI;
    c_st.site = &nb_emlrtRSI;
    info_t = LAPACKE_dgeqp3(102, m_t, (ptrdiff_t)A->size[1], &A->data[0], m_t,
      &jpvt_t->data[0], &tau->data[0]);
    m = (int32_T)info_t;
    b_st.site = &gb_emlrtRSI;
    c_st.site = &ob_emlrtRSI;
    if (m != 0) {
      p = true;
      b_p = false;
      if (m == -4) {
        b_p = true;
      }

      if (!b_p) {
        if (m == -1010) {
          c_st.site = &pb_emlrtRSI;
          b_error(&c_st);
        } else {
          c_st.site = &qb_emlrtRSI;
          c_error(&c_st, m);
        }
      }
    } else {
      p = false;
    }

    if (p) {
      i2 = A->size[0] * A->size[1];
      emxEnsureCapacity(&st, (emxArray__common *)A, i2, sizeof(real_T),
                        &f_emlrtRTEI);
      m = A->size[1];
      for (i2 = 0; i2 < m; i2++) {
        loop_ub = A->size[0];
        for (i3 = 0; i3 < loop_ub; i3++) {
          A->data[i3 + A->size[0] * i2] = rtNaN;
        }
      }

      m = tau->size[0];
      i2 = tau->size[0];
      tau->size[0] = m;
      emxEnsureCapacity(&st, (emxArray__common *)tau, i2, sizeof(real_T),
                        &f_emlrtRTEI);
      for (i2 = 0; i2 < m; i2++) {
        tau->data[i2] = rtNaN;
      }

      b_st.site = &hb_emlrtRSI;
      c_st.site = &jb_emlrtRSI;
      d_st.site = &kb_emlrtRSI;
      e_st.site = &lb_emlrtRSI;
      eml_signed_integer_colon(&e_st, n, jpvt);
    } else {
      i2 = jpvt->size[0] * jpvt->size[1];
      jpvt->size[0] = 1;
      jpvt->size[1] = jpvt_t->size[0];
      emxEnsureCapacity(&st, (emxArray__common *)jpvt, i2, sizeof(int32_T),
                        &f_emlrtRTEI);
      m = jpvt_t->size[0];
      for (i2 = 0; i2 < m; i2++) {
        jpvt->data[jpvt->size[0] * i2] = (int32_T)jpvt_t->data[i2];
      }
    }

    emxFree_ptrdiff_t(&jpvt_t);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (xgeqp3.c) */
