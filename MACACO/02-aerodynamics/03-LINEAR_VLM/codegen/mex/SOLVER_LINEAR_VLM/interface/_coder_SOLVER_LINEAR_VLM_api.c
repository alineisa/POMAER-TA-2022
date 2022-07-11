/*
 * _coder_SOLVER_LINEAR_VLM_api.c
 *
 * Code generation for function '_coder_SOLVER_LINEAR_VLM_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "SOLVER_LINEAR_VLM.h"
#include "_coder_SOLVER_LINEAR_VLM_api.h"
#include "SOLVER_LINEAR_VLM_emxutil.h"
#include "SOLVER_LINEAR_VLM_data.h"

/* Variable Definitions */
static emlrtRTEInfo i_emlrtRTEI = { 1, /* lineNo */
  1,                                   /* colNo */
  "_coder_SOLVER_LINEAR_VLM_api",      /* fName */
  ""                                   /* pName */
};

/* Function Declarations */
static const mxArray *b_emlrt_marshallOut(const real_T u_data[], const int32_T
  u_size[1]);
static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *nmesh,
  const char_T *identifier);
static real_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *PC34, const
  char_T *identifier, real_T **y_data, int32_T y_size[2]);
static const mxArray *emlrt_marshallOut(const emxArray_real_T *u);
static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T **y_data, int32_T y_size[2]);
static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *c, const
  char_T *identifier, real_T **y_data, int32_T y_size[1]);
static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T **y_data, int32_T y_size[1]);
static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *Vort, const
  char_T *identifier, emxArray_real_T *y);
static void j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static real_T l_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId);
static void m_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T **ret_data, int32_T ret_size[2]);
static void n_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T **ret_data, int32_T ret_size[1]);
static void o_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);

/* Function Definitions */
static const mxArray *b_emlrt_marshallOut(const real_T u_data[], const int32_T
  u_size[1])
{
  const mxArray *y;
  const mxArray *m4;
  static const int32_T iv10[1] = { 0 };

  y = NULL;
  m4 = emlrtCreateNumericArray(1, iv10, mxDOUBLE_CLASS, mxREAL);
  mxSetData((mxArray *)m4, (void *)&u_data[0]);
  emlrtSetDimensions((mxArray *)m4, u_size, 1);
  emlrtAssign(&y, m4);
  return y;
}

static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *nmesh,
  const char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = d_emlrt_marshallIn(sp, emlrtAlias(nmesh), &thisId);
  emlrtDestroyArray(&nmesh);
  return y;
}

static real_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = l_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *PC34, const
  char_T *identifier, real_T **y_data, int32_T y_size[2])
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  f_emlrt_marshallIn(sp, emlrtAlias(PC34), &thisId, y_data, y_size);
  emlrtDestroyArray(&PC34);
}

static const mxArray *emlrt_marshallOut(const emxArray_real_T *u)
{
  const mxArray *y;
  const mxArray *m3;
  static const int32_T iv9[1] = { 0 };

  y = NULL;
  m3 = emlrtCreateNumericArray(1, iv9, mxDOUBLE_CLASS, mxREAL);
  mxSetData((mxArray *)m3, (void *)&u->data[0]);
  emlrtSetDimensions((mxArray *)m3, u->size, 1);
  emlrtAssign(&y, m3);
  return y;
}

static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T **y_data, int32_T y_size[2])
{
  m_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y_data, y_size);
  emlrtDestroyArray(&u);
}

static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *c, const
  char_T *identifier, real_T **y_data, int32_T y_size[1])
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  h_emlrt_marshallIn(sp, emlrtAlias(c), &thisId, y_data, y_size);
  emlrtDestroyArray(&c);
}

static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T **y_data, int32_T y_size[1])
{
  n_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y_data, y_size);
  emlrtDestroyArray(&u);
}

static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *Vort, const
  char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  j_emlrt_marshallIn(sp, emlrtAlias(Vort), &thisId, y);
  emlrtDestroyArray(&Vort);
}

static void j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  o_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static real_T l_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId)
{
  real_T ret;
  static const int32_T dims = 0;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 0U, &dims);
  ret = *(real_T *)mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static void m_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T **ret_data, int32_T ret_size[2])
{
  static const int32_T dims[2] = { 1000, 3 };

  const boolean_T bv0[2] = { true, false };

  int32_T iv11[2];
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims, &bv0[0],
    iv11);
  ret_size[0] = iv11[0];
  ret_size[1] = iv11[1];
  *ret_data = (real_T *)mxGetData(src);
  emlrtDestroyArray(&src);
}

static void n_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T **ret_data, int32_T ret_size[1])
{
  static const int32_T dims[1] = { 1000 };

  const boolean_T bv1[1] = { true };

  int32_T iv12[1];
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 1U, dims, &bv1[0],
    iv12);
  ret_size[0] = iv12[0];
  *ret_data = (real_T *)mxGetData(src);
  emlrtDestroyArray(&src);
}

static void o_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  static const int32_T dims[3] = { 1000, 100, 3 };

  const boolean_T bv2[3] = { true, true, false };

  int32_T iv13[3];
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 3U, dims, &bv2[0],
    iv13);
  ret->size[0] = iv13[0];
  ret->size[1] = iv13[1];
  ret->size[2] = iv13[2];
  ret->allocatedSize = ret->size[0] * ret->size[1] * ret->size[2];
  ret->data = (real_T *)mxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

void SOLVER_LINEAR_VLM_api(const mxArray * const prhs[10], const mxArray *plhs[2])
{
  real_T (*cl_data)[1000];
  emxArray_real_T *Vort;
  emxArray_real_T *G;
  real_T nmesh;
  real_T IsSymSimulation;
  real_T IsSymSimulation_factor;
  real_T (*PC34_data)[3000];
  int32_T PC34_size[2];
  real_T (*c_data)[1000];
  int32_T c_size[1];
  real_T (*n_data)[3000];
  int32_T n_size[2];
  real_T (*alpha_data)[1000];
  int32_T alpha_size[1];
  real_T (*beta_data)[1000];
  int32_T beta_size[1];
  real_T Voo;
  int32_T cl_size[1];
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  cl_data = (real_T (*)[1000])mxMalloc(sizeof(real_T [1000]));
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  emxInit_real_T(&st, &Vort, 3, &i_emlrtRTEI, true);
  emxInit_real_T2(&st, &G, 1, &i_emlrtRTEI, true);

  /* Marshall function inputs */
  nmesh = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[0]), "nmesh");
  IsSymSimulation = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[1]),
    "IsSymSimulation");
  IsSymSimulation_factor = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[2]),
    "IsSymSimulation_factor");
  e_emlrt_marshallIn(&st, emlrtAlias(prhs[3]), "PC34", (real_T **)&PC34_data,
                     PC34_size);
  g_emlrt_marshallIn(&st, emlrtAlias(prhs[4]), "c", (real_T **)&c_data, c_size);
  i_emlrt_marshallIn(&st, emlrtAlias(prhs[5]), "Vort", Vort);
  e_emlrt_marshallIn(&st, emlrtAlias(prhs[6]), "n", (real_T **)&n_data, n_size);
  g_emlrt_marshallIn(&st, emlrtAlias(prhs[7]), "alpha", (real_T **)&alpha_data,
                     alpha_size);
  g_emlrt_marshallIn(&st, emlrtAlias(prhs[8]), "beta", (real_T **)&beta_data,
                     beta_size);
  Voo = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[9]), "Voo");

  /* Invoke the target function */
  SOLVER_LINEAR_VLM(&st, nmesh, IsSymSimulation, IsSymSimulation_factor,
                    *PC34_data, PC34_size, *c_data, c_size, Vort, *n_data,
                    n_size, *alpha_data, alpha_size, *beta_data, beta_size, Voo,
                    G, *cl_data, cl_size);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(G);
  plhs[1] = b_emlrt_marshallOut(*cl_data, cl_size);
  G->canFreeData = false;
  emxFree_real_T(&G);
  Vort->canFreeData = false;
  emxFree_real_T(&Vort);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

/* End of code generation (_coder_SOLVER_LINEAR_VLM_api.c) */
