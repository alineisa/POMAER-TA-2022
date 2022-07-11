/*
 * SOLVER_LINEAR_VLM.c
 *
 * Code generation for function 'SOLVER_LINEAR_VLM'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "SOLVER_LINEAR_VLM.h"
#include "cosd.h"
#include "sind.h"
#include "SOLVER_LINEAR_VLM_emxutil.h"
#include "error.h"
#include "eml_int_forloop_overflow_check.h"
#include "VORTEX_INDUCED.h"
#include "linsolve.h"
#include "SOLVER_LINEAR_VLM_data.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 21,    /* lineNo */
  "SOLVER_LINEAR_VLM",                 /* fcnName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m"/* pathName */
};

static emlrtRSInfo b_emlrtRSI = { 27,  /* lineNo */
  "SOLVER_LINEAR_VLM",                 /* fcnName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m"/* pathName */
};

static emlrtRSInfo c_emlrtRSI = { 28,  /* lineNo */
  "SOLVER_LINEAR_VLM",                 /* fcnName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m"/* pathName */
};

static emlrtRSInfo d_emlrtRSI = { 34,  /* lineNo */
  "SOLVER_LINEAR_VLM",                 /* fcnName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m"/* pathName */
};

static emlrtRSInfo e_emlrtRSI = { 48,  /* lineNo */
  "SOLVER_LINEAR_VLM",                 /* fcnName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m"/* pathName */
};

static emlrtRSInfo f_emlrtRSI = { 54,  /* lineNo */
  "SOLVER_LINEAR_VLM",                 /* fcnName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m"/* pathName */
};

static emlrtRSInfo l_emlrtRSI = { 12,  /* lineNo */
  "toLogicalCheck",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\toLogicalCheck.m"/* pathName */
};

static emlrtRSInfo m_emlrtRSI = { 57,  /* lineNo */
  "rot90",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\lib\\matlab\\elmat\\rot90.m"/* pathName */
};

static emlrtRSInfo n_emlrtRSI = { 58,  /* lineNo */
  "rot90",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\lib\\matlab\\elmat\\rot90.m"/* pathName */
};

static emlrtRSInfo r_emlrtRSI = { 20,  /* lineNo */
  "cat",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\cat.m"/* pathName */
};

static emlrtRSInfo s_emlrtRSI = { 100, /* lineNo */
  "cat",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\cat.m"/* pathName */
};

static emlrtRTEInfo emlrtRTEI = { 1,   /* lineNo */
  22,                                  /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m"/* pName */
};

static emlrtRTEInfo b_emlrtRTEI = { 8, /* lineNo */
  1,                                   /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m"/* pName */
};

static emlrtRTEInfo c_emlrtRTEI = { 9, /* lineNo */
  1,                                   /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m"/* pName */
};

static emlrtRTEInfo l_emlrtRTEI = { 17,/* lineNo */
  7,                                   /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m"/* pName */
};

static emlrtRTEInfo m_emlrtRTEI = { 18,/* lineNo */
  8,                                   /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m"/* pName */
};

static emlrtBCInfo emlrtBCI = { -1,    /* iFirst */
  -1,                                  /* iLast */
  21,                                  /* lineNo */
  37,                                  /* colNo */
  "PC34",                              /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo b_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  21,                                  /* lineNo */
  47,                                  /* colNo */
  "Vort",                              /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo c_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  21,                                  /* lineNo */
  8,                                   /* colNo */
  "Vind",                              /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo d_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  21,                                  /* lineNo */
  10,                                  /* colNo */
  "Vind",                              /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo e_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  28,                                  /* lineNo */
  39,                                  /* colNo */
  "w",                                 /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo f_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  28,                                  /* lineNo */
  43,                                  /* colNo */
  "w",                                 /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo emlrtDCI = { 28,    /* lineNo */
  45,                                  /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo g_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  28,                                  /* lineNo */
  45,                                  /* colNo */
  "w",                                 /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo h_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  28,                                  /* lineNo */
  7,                                   /* colNo */
  "w",                                 /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo b_emlrtDCI = { 28,  /* lineNo */
  12,                                  /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo i_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  28,                                  /* lineNo */
  12,                                  /* colNo */
  "w",                                 /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo j_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  28,                                  /* lineNo */
  22,                                  /* colNo */
  "w",                                 /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo emlrtECI = { -1,    /* nDims */
  28,                                  /* lineNo */
  3,                                   /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m"/* pName */
};

static emlrtECInfo b_emlrtECI = { -1,  /* nDims */
  34,                                  /* lineNo */
  23,                                  /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m"/* pName */
};

static emlrtECInfo c_emlrtECI = { -1,  /* nDims */
  34,                                  /* lineNo */
  48,                                  /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m"/* pName */
};

static emlrtECInfo d_emlrtECI = { -1,  /* nDims */
  34,                                  /* lineNo */
  1,                                   /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m"/* pName */
};

static emlrtRTEInfo n_emlrtRTEI = { 40,/* lineNo */
  7,                                   /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m"/* pName */
};

static emlrtBCInfo k_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  42,                                  /* lineNo */
  22,                                  /* colNo */
  "V_vec",                             /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo o_emlrtRTEI = { 281,/* lineNo */
  27,                                  /* colNo */
  "cat",                               /* fName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\eml\\+coder\\+internal\\cat.m"/* pName */
};

static emlrtRTEInfo p_emlrtRTEI = { 13,/* lineNo */
  15,                                  /* colNo */
  "rdivide",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\lib\\matlab\\ops\\rdivide.m"/* pName */
};

static emlrtDCInfo c_emlrtDCI = { 8,   /* lineNo */
  14,                                  /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo d_emlrtDCI = { 8,   /* lineNo */
  14,                                  /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  4                                    /* checkKind */
};

static emlrtDCInfo e_emlrtDCI = { 8,   /* lineNo */
  20,                                  /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo f_emlrtDCI = { 8,   /* lineNo */
  20,                                  /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  4                                    /* checkKind */
};

static emlrtDCInfo g_emlrtDCI = { 9,   /* lineNo */
  14,                                  /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo h_emlrtDCI = { 9,   /* lineNo */
  20,                                  /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo i_emlrtDCI = { 39,  /* lineNo */
  11,                                  /* colNo */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo l_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  41,                                  /* lineNo */
  9,                                   /* colNo */
  "n",                                 /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo m_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  41,                                  /* lineNo */
  16,                                  /* colNo */
  "n",                                 /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo n_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  41,                                  /* lineNo */
  23,                                  /* colNo */
  "n",                                 /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo o_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  42,                                  /* lineNo */
  4,                                   /* colNo */
  "B",                                 /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo p_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  24,                                  /* lineNo */
  17,                                  /* colNo */
  "Vind",                              /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo q_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  24,                                  /* lineNo */
  19,                                  /* colNo */
  "Vind",                              /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo r_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  24,                                  /* lineNo */
  26,                                  /* colNo */
  "n",                                 /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo s_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  24,                                  /* lineNo */
  38,                                  /* colNo */
  "Vind",                              /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo t_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  24,                                  /* lineNo */
  40,                                  /* colNo */
  "Vind",                              /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo u_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  24,                                  /* lineNo */
  47,                                  /* colNo */
  "n",                                 /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo v_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  24,                                  /* lineNo */
  59,                                  /* colNo */
  "Vind",                              /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo w_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  24,                                  /* lineNo */
  61,                                  /* colNo */
  "Vind",                              /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo x_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  24,                                  /* lineNo */
  68,                                  /* colNo */
  "n",                                 /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo y_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  24,                                  /* lineNo */
  5,                                   /* colNo */
  "w",                                 /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ab_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  24,                                  /* lineNo */
  7,                                   /* colNo */
  "w",                                 /* aName */
  "SOLVER_LINEAR_VLM",                 /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\SOLVER_LINEAR_VLM.m",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void SOLVER_LINEAR_VLM(const emlrtStack *sp, real_T nmesh, real_T
  IsSymSimulation, real_T IsSymSimulation_factor, const real_T PC34_data[],
  const int32_T PC34_size[2], const real_T c_data[], const int32_T c_size[1],
  const emxArray_real_T *Vort, const real_T n_data[], const int32_T n_size[2],
  const real_T alpha_data[], const int32_T alpha_size[1], const real_T
  beta_data[], const int32_T beta_size[1], real_T Voo, emxArray_real_T *G,
  real_T cl_data[], int32_T cl_size[1])
{
  emxArray_real_T *Vind;
  int32_T i0;
  int32_T loop_ub;
  emxArray_real_T *w;
  int32_T i;
  real_T y;
  int32_T j;
  int32_T Voo_vec_size_idx_0;
  int32_T b_loop_ub;
  real_T PC34[3];
  int32_T varargin_1_size[1];
  real_T Voo_vec_data[3000];
  int32_T c_loop_ub;
  int32_T Vort_size[3];
  real_T varargin_1_data[1000];
  int32_T tmp_size[1];
  int32_T i1;
  emxArray_int32_T *r0;
  real_T Vort_data[300];
  real_T N[3];
  real_T tmp_data[1000];
  int32_T varargin_2_size[1];
  emxArray_int32_T *r1;
  real_T varargin_2_data[1000];
  int32_T b_tmp_size[1];
  emxArray_real_T *A;
  real_T b_tmp_data[1000];
  emxArray_real_T *r2;
  int32_T varargin_3_size[1];
  int16_T c_tmp_data[1000];
  real_T varargin_3_data[1000];
  int32_T iv0[2];
  boolean_T p;
  int32_T c_tmp_size[2];
  real_T d_tmp_data[3000];
  emxArray_real_T *x;
  int32_T varargin_1[2];
  int16_T varargin_2[2];
  boolean_T b_p;
  boolean_T exitg1;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  emxInit_real_T(sp, &Vind, 3, &b_emlrtRTEI, true);

  /* SOLVER_LINEAR_VLM Summary of this function goes here */
  /*    Detailed explanation goes here */
  /*  MATRIX OF INFLUENCE */
  /*  ------------------------------------ */
  i0 = Vind->size[0] * Vind->size[1] * Vind->size[2];
  if (!(nmesh >= 0.0)) {
    emlrtNonNegativeCheckR2012b(nmesh, &d_emlrtDCI, sp);
  }

  if (nmesh != (int32_T)muDoubleScalarFloor(nmesh)) {
    emlrtIntegerCheckR2012b(nmesh, &c_emlrtDCI, sp);
  }

  Vind->size[0] = (int32_T)nmesh;
  if (!(nmesh >= 0.0)) {
    emlrtNonNegativeCheckR2012b(nmesh, &f_emlrtDCI, sp);
  }

  if (nmesh != (int32_T)muDoubleScalarFloor(nmesh)) {
    emlrtIntegerCheckR2012b(nmesh, &e_emlrtDCI, sp);
  }

  Vind->size[1] = (int32_T)nmesh;
  Vind->size[2] = 3;
  emxEnsureCapacity(sp, (emxArray__common *)Vind, i0, sizeof(real_T), &emlrtRTEI);
  if (!(nmesh >= 0.0)) {
    emlrtNonNegativeCheckR2012b(nmesh, &d_emlrtDCI, sp);
  }

  if (nmesh != (int32_T)muDoubleScalarFloor(nmesh)) {
    emlrtIntegerCheckR2012b(nmesh, &c_emlrtDCI, sp);
  }

  if (!(nmesh >= 0.0)) {
    emlrtNonNegativeCheckR2012b(nmesh, &f_emlrtDCI, sp);
  }

  if (nmesh != (int32_T)muDoubleScalarFloor(nmesh)) {
    emlrtIntegerCheckR2012b(nmesh, &e_emlrtDCI, sp);
  }

  loop_ub = (int32_T)nmesh * (int32_T)nmesh * 3;
  for (i0 = 0; i0 < loop_ub; i0++) {
    Vind->data[i0] = 0.0;
  }

  emxInit_real_T1(sp, &w, 2, &c_emlrtRTEI, true);
  i0 = w->size[0] * w->size[1];
  if (nmesh != (int32_T)muDoubleScalarFloor(nmesh)) {
    emlrtIntegerCheckR2012b(nmesh, &g_emlrtDCI, sp);
  }

  w->size[0] = (int32_T)nmesh;
  if (nmesh != (int32_T)muDoubleScalarFloor(nmesh)) {
    emlrtIntegerCheckR2012b(nmesh, &h_emlrtDCI, sp);
  }

  w->size[1] = (int32_T)nmesh;
  emxEnsureCapacity(sp, (emxArray__common *)w, i0, sizeof(real_T), &emlrtRTEI);
  if (nmesh != (int32_T)muDoubleScalarFloor(nmesh)) {
    emlrtIntegerCheckR2012b(nmesh, &g_emlrtDCI, sp);
    emlrtIntegerCheckR2012b(nmesh, &h_emlrtDCI, sp);
  }

  loop_ub = (int32_T)nmesh * (int32_T)nmesh;
  for (i0 = 0; i0 < loop_ub; i0++) {
    w->data[i0] = 0.0;
  }

  emlrtForLoopVectorCheckR2012b(1.0, 1.0, nmesh, mxDOUBLE_CLASS, (int32_T)nmesh,
    &l_emlrtRTEI, sp);
  i = 1;
  while (i - 1 <= (int32_T)nmesh - 1) {
    /*  influencia nos pontos de controle i */
    y = nmesh * IsSymSimulation_factor;
    emlrtForLoopVectorCheckR2012b(1.0, 1.0, y, mxDOUBLE_CLASS, (int32_T)y,
      &m_emlrtRTEI, sp);
    j = 1;
    while (j - 1 <= (int32_T)y - 1) {
      /*  pelos segmentos de vortice j */
      /*  Velocidade induzida em i por um vortice j de intensidade unitária */
      if (!((i >= 1) && (i <= PC34_size[0]))) {
        emlrtDynamicBoundsCheckR2012b(i, 1, PC34_size[0], &emlrtBCI, sp);
      }

      for (i0 = 0; i0 < 3; i0++) {
        PC34[i0] = PC34_data[(i + PC34_size[0] * i0) - 1];
      }

      loop_ub = Vort->size[1];
      i0 = Vort->size[0];
      if (!((j >= 1) && (j <= i0))) {
        emlrtDynamicBoundsCheckR2012b(j, 1, i0, &b_emlrtBCI, sp);
      }

      Vort_size[0] = 1;
      Vort_size[1] = loop_ub;
      Vort_size[2] = 3;
      for (i0 = 0; i0 < 3; i0++) {
        for (i1 = 0; i1 < loop_ub; i1++) {
          Vort_data[i1 + loop_ub * i0] = Vort->data[((j + Vort->size[0] * i1) +
            Vort->size[0] * Vort->size[1] * i0) - 1];
        }
      }

      st.site = &emlrtRSI;
      VORTEX_INDUCED(&st, PC34, Vort_data, Vort_size, N);
      c_loop_ub = Vind->size[0];
      Voo_vec_size_idx_0 = Vind->size[1];
      if (!((j >= 1) && (j <= Voo_vec_size_idx_0))) {
        emlrtDynamicBoundsCheckR2012b(j, 1, Voo_vec_size_idx_0, &d_emlrtBCI, sp);
      }

      if (!((i >= 1) && (i <= c_loop_ub))) {
        emlrtDynamicBoundsCheckR2012b(i, 1, c_loop_ub, &c_emlrtBCI, sp);
      }

      for (i0 = 0; i0 < 3; i0++) {
        Vind->data[((i + Vind->size[0] * (j - 1)) + Vind->size[0] * Vind->size[1]
                    * i0) - 1] = N[i0];
      }

      /*  Coeficientes de incluencia  w = (Vind . n) */
      i0 = Vind->size[0];
      if (!((i >= 1) && (i <= i0))) {
        emlrtDynamicBoundsCheckR2012b(i, 1, i0, &p_emlrtBCI, sp);
      }

      i0 = Vind->size[1];
      if (!((j >= 1) && (j <= i0))) {
        emlrtDynamicBoundsCheckR2012b(j, 1, i0, &q_emlrtBCI, sp);
      }

      if (!((i >= 1) && (i <= n_size[0]))) {
        emlrtDynamicBoundsCheckR2012b(i, 1, n_size[0], &r_emlrtBCI, sp);
      }

      i0 = Vind->size[0];
      if (!((i >= 1) && (i <= i0))) {
        emlrtDynamicBoundsCheckR2012b(i, 1, i0, &s_emlrtBCI, sp);
      }

      i0 = Vind->size[1];
      if (!((j >= 1) && (j <= i0))) {
        emlrtDynamicBoundsCheckR2012b(j, 1, i0, &t_emlrtBCI, sp);
      }

      if (!((i >= 1) && (i <= n_size[0]))) {
        emlrtDynamicBoundsCheckR2012b(i, 1, n_size[0], &u_emlrtBCI, sp);
      }

      i0 = Vind->size[0];
      if (!((i >= 1) && (i <= i0))) {
        emlrtDynamicBoundsCheckR2012b(i, 1, i0, &v_emlrtBCI, sp);
      }

      i0 = Vind->size[1];
      if (!((j >= 1) && (j <= i0))) {
        emlrtDynamicBoundsCheckR2012b(j, 1, i0, &w_emlrtBCI, sp);
      }

      if (!((i >= 1) && (i <= n_size[0]))) {
        emlrtDynamicBoundsCheckR2012b(i, 1, n_size[0], &x_emlrtBCI, sp);
      }

      i0 = w->size[0];
      if (!((i >= 1) && (i <= i0))) {
        emlrtDynamicBoundsCheckR2012b(i, 1, i0, &y_emlrtBCI, sp);
      }

      i0 = w->size[1];
      if (!((j >= 1) && (j <= i0))) {
        emlrtDynamicBoundsCheckR2012b(j, 1, i0, &ab_emlrtBCI, sp);
      }

      w->data[(i + w->size[0] * (j - 1)) - 1] = (Vind->data[(i + Vind->size[0] *
        (j - 1)) - 1] * n_data[i - 1] + Vind->data[((i + Vind->size[0] * (j - 1))
        + Vind->size[0] * Vind->size[1]) - 1] * n_data[(i + n_size[0]) - 1]) +
        Vind->data[((i + Vind->size[0] * (j - 1)) + (Vind->size[0] * Vind->size
        [1] << 1)) - 1] * n_data[(i + (n_size[0] << 1)) - 1];
      j++;
      if (*emlrtBreakCheckR2012bFlagVar != 0) {
        emlrtBreakCheckR2012b(sp);
      }
    }

    i++;
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }
  }

  emxFree_real_T(&Vind);
  st.site = &b_emlrtRSI;
  if (muDoubleScalarIsNaN(IsSymSimulation)) {
    b_st.site = &l_emlrtRSI;
    error(&b_st);
  }

  if (IsSymSimulation != 0.0) {
    if (1 > w->size[0]) {
      loop_ub = 0;
    } else {
      i0 = w->size[0];
      loop_ub = w->size[0];
      if (!((loop_ub >= 1) && (loop_ub <= i0))) {
        emlrtDynamicBoundsCheckR2012b(loop_ub, 1, i0, &e_emlrtBCI, sp);
      }
    }

    y = nmesh / 2.0;
    if (1.0 > y) {
      b_loop_ub = 0;
    } else {
      i0 = w->size[1];
      if (!(1 <= i0)) {
        emlrtDynamicBoundsCheckR2012b(1, 1, i0, &f_emlrtBCI, sp);
      }

      if (y != (int32_T)muDoubleScalarFloor(y)) {
        emlrtIntegerCheckR2012b(y, &emlrtDCI, sp);
      }

      i0 = w->size[1];
      b_loop_ub = (int32_T)y;
      if (!((b_loop_ub >= 1) && (b_loop_ub <= i0))) {
        emlrtDynamicBoundsCheckR2012b(b_loop_ub, 1, i0, &g_emlrtBCI, sp);
      }
    }

    if (1 > w->size[0]) {
      c_loop_ub = 0;
    } else {
      i0 = w->size[0];
      c_loop_ub = w->size[0];
      if (!((c_loop_ub >= 1) && (c_loop_ub <= i0))) {
        emlrtDynamicBoundsCheckR2012b(c_loop_ub, 1, i0, &h_emlrtBCI, sp);
      }
    }

    y = nmesh / 2.0;
    if (y + 1.0 > w->size[1]) {
      i0 = 0;
      Voo_vec_size_idx_0 = 0;
    } else {
      if (y + 1.0 != (int32_T)muDoubleScalarFloor(y + 1.0)) {
        emlrtIntegerCheckR2012b(y + 1.0, &b_emlrtDCI, sp);
      }

      i0 = w->size[1];
      i1 = (int32_T)(y + 1.0);
      if (!((i1 >= 1) && (i1 <= i0))) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, i0, &i_emlrtBCI, sp);
      }

      i0 = i1 - 1;
      i1 = w->size[1];
      Voo_vec_size_idx_0 = w->size[1];
      if (!((Voo_vec_size_idx_0 >= 1) && (Voo_vec_size_idx_0 <= i1))) {
        emlrtDynamicBoundsCheckR2012b(Voo_vec_size_idx_0, 1, i1, &j_emlrtBCI, sp);
      }
    }

    emxInit_int32_T(sp, &r0, 1, &emlrtRTEI, true);
    i1 = r0->size[0];
    r0->size[0] = c_loop_ub;
    emxEnsureCapacity(sp, (emxArray__common *)r0, i1, sizeof(int32_T),
                      &emlrtRTEI);
    for (i1 = 0; i1 < c_loop_ub; i1++) {
      r0->data[i1] = i1;
    }

    emxInit_int32_T(sp, &r1, 1, &emlrtRTEI, true);
    i1 = r1->size[0];
    r1->size[0] = Voo_vec_size_idx_0 - i0;
    emxEnsureCapacity(sp, (emxArray__common *)r1, i1, sizeof(int32_T),
                      &emlrtRTEI);
    c_loop_ub = Voo_vec_size_idx_0 - i0;
    for (i1 = 0; i1 < c_loop_ub; i1++) {
      r1->data[i1] = i0 + i1;
    }

    emxInit_real_T1(sp, &A, 2, &emlrtRTEI, true);
    st.site = &c_emlrtRSI;
    i0 = A->size[0] * A->size[1];
    A->size[0] = loop_ub;
    A->size[1] = b_loop_ub;
    emxEnsureCapacity(&st, (emxArray__common *)A, i0, sizeof(real_T), &emlrtRTEI);
    for (i0 = 0; i0 < b_loop_ub; i0++) {
      for (i1 = 0; i1 < loop_ub; i1++) {
        A->data[i1 + A->size[0] * i0] = w->data[i1 + w->size[0] * i0];
      }
    }

    emxInit_real_T1(&st, &r2, 2, &emlrtRTEI, true);
    i0 = r2->size[0] * r2->size[1];
    r2->size[0] = loop_ub;
    r2->size[1] = b_loop_ub;
    emxEnsureCapacity(&st, (emxArray__common *)r2, i0, sizeof(real_T),
                      &emlrtRTEI);
    b_st.site = &m_emlrtRSI;
    if ((!(1 > b_loop_ub)) && (b_loop_ub > 2147483646)) {
      c_st.site = &k_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    for (j = 1; j <= b_loop_ub; j++) {
      b_st.site = &n_emlrtRSI;
      if ((!(1 > loop_ub)) && (loop_ub > 2147483646)) {
        c_st.site = &k_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (i = 1; i <= loop_ub; i++) {
        c_loop_ub = r2->size[0];
        r2->data[(i + c_loop_ub * (j - 1)) - 1] = A->data[(loop_ub - i) +
          loop_ub * (b_loop_ub - j)];
      }
    }

    emxFree_real_T(&A);
    iv0[0] = r0->size[0];
    iv0[1] = r1->size[0];
    emlrtSubAssignSizeCheckR2012b(iv0, 2, *(int32_T (*)[2])r2->size, 2,
      &emlrtECI, sp);
    loop_ub = r2->size[1];
    for (i0 = 0; i0 < loop_ub; i0++) {
      b_loop_ub = r2->size[0];
      for (i1 = 0; i1 < b_loop_ub; i1++) {
        w->data[r0->data[i1] + w->size[0] * r1->data[i0]] = r2->data[i1 +
          r2->size[0] * i0];
      }
    }

    emxFree_real_T(&r2);
    emxFree_int32_T(&r1);
    emxFree_int32_T(&r0);
  }

  /*  FREESTREAM COMPONENTS */
  /*  ------------------------------------ */
  Voo_vec_size_idx_0 = alpha_size[0];
  loop_ub = alpha_size[0] * 3;
  for (i0 = 0; i0 < loop_ub; i0++) {
    Voo_vec_data[i0] = 0.0;
  }

  varargin_1_size[0] = alpha_size[0];
  loop_ub = alpha_size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    varargin_1_data[i0] = alpha_data[i0];
  }

  st.site = &d_emlrtRSI;
  b_cosd(varargin_1_data, varargin_1_size);
  tmp_size[0] = beta_size[0];
  loop_ub = beta_size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    tmp_data[i0] = beta_data[i0];
  }

  st.site = &d_emlrtRSI;
  b_cosd(tmp_data, tmp_size);
  if (varargin_1_size[0] != tmp_size[0]) {
    emlrtSizeEqCheck1DR2012b(varargin_1_size[0], tmp_size[0], &b_emlrtECI, sp);
  }

  varargin_2_size[0] = alpha_size[0];
  loop_ub = alpha_size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    varargin_2_data[i0] = alpha_data[i0];
  }

  st.site = &d_emlrtRSI;
  b_cosd(varargin_2_data, varargin_2_size);
  loop_ub = varargin_2_size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    varargin_2_data[i0] = -varargin_2_data[i0];
  }

  b_tmp_size[0] = beta_size[0];
  loop_ub = beta_size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    b_tmp_data[i0] = beta_data[i0];
  }

  st.site = &d_emlrtRSI;
  b_sind(b_tmp_data, b_tmp_size);
  if (varargin_2_size[0] != b_tmp_size[0]) {
    emlrtSizeEqCheck1DR2012b(varargin_2_size[0], b_tmp_size[0], &c_emlrtECI, sp);
  }

  loop_ub = (int16_T)((int16_T)alpha_size[0] - 1);
  for (i0 = 0; i0 <= loop_ub; i0++) {
    c_tmp_data[i0] = (int16_T)i0;
  }

  varargin_3_size[0] = alpha_size[0];
  loop_ub = alpha_size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    varargin_3_data[i0] = alpha_data[i0];
  }

  st.site = &d_emlrtRSI;
  b_sind(varargin_3_data, varargin_3_size);
  st.site = &d_emlrtRSI;
  loop_ub = varargin_1_size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    varargin_1_data[i0] *= tmp_data[i0];
  }

  loop_ub = varargin_2_size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    varargin_2_data[i0] *= b_tmp_data[i0];
  }

  b_st.site = &r_emlrtRSI;
  c_st.site = &s_emlrtRSI;
  p = true;
  if (varargin_2_size[0] != varargin_1_size[0]) {
    p = false;
  }

  if (!p) {
    emlrtErrorWithMessageIdR2012b(&c_st, &o_emlrtRTEI,
      "MATLAB:catenate:matrixDimensionMismatch", 0);
  }

  if (varargin_3_size[0] != varargin_1_size[0]) {
    p = false;
  }

  if (!p) {
    emlrtErrorWithMessageIdR2012b(&c_st, &o_emlrtRTEI,
      "MATLAB:catenate:matrixDimensionMismatch", 0);
  }

  c_tmp_size[0] = varargin_1_size[0];
  c_tmp_size[1] = 3;
  loop_ub = varargin_1_size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    d_tmp_data[i0] = Voo * varargin_1_data[i0];
  }

  loop_ub = varargin_2_size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    d_tmp_data[i0 + c_tmp_size[0]] = Voo * varargin_2_data[i0];
  }

  loop_ub = varargin_3_size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    d_tmp_data[i0 + (c_tmp_size[0] << 1)] = Voo * varargin_3_data[i0];
  }

  iv0[0] = (int16_T)((int16_T)alpha_size[0] - 1) + 1;
  iv0[1] = 3;
  emlrtSubAssignSizeCheckR2012b(iv0, 2, c_tmp_size, 2, &d_emlrtECI, sp);
  loop_ub = varargin_1_size[0];
  for (i0 = 0; i0 < 3; i0++) {
    for (i1 = 0; i1 < loop_ub; i1++) {
      Voo_vec_data[c_tmp_data[i1] + Voo_vec_size_idx_0 * i0] = d_tmp_data[i1 +
        c_tmp_size[0] * i0];
    }
  }

  /*  ESCOAMENTO NAO PERTUBADO */
  /*  --------------------------------- */
  i0 = G->size[0];
  if (nmesh != (int32_T)muDoubleScalarFloor(nmesh)) {
    emlrtIntegerCheckR2012b(nmesh, &i_emlrtDCI, sp);
  }

  G->size[0] = (int32_T)nmesh;
  emxEnsureCapacity(sp, (emxArray__common *)G, i0, sizeof(real_T), &emlrtRTEI);
  if (nmesh != (int32_T)muDoubleScalarFloor(nmesh)) {
    emlrtIntegerCheckR2012b(nmesh, &i_emlrtDCI, sp);
  }

  loop_ub = (int32_T)nmesh;
  for (i0 = 0; i0 < loop_ub; i0++) {
    G->data[i0] = 0.0;
  }

  emlrtForLoopVectorCheckR2012b(1.0, 1.0, nmesh, mxDOUBLE_CLASS, (int32_T)nmesh,
    &n_emlrtRTEI, sp);
  i = 1;
  while (i - 1 <= (int32_T)nmesh - 1) {
    if (!((i >= 1) && (i <= n_size[0]))) {
      emlrtDynamicBoundsCheckR2012b(i, 1, n_size[0], &l_emlrtBCI, sp);
    }

    N[0] = n_data[i - 1];
    if (!((i >= 1) && (i <= n_size[0]))) {
      emlrtDynamicBoundsCheckR2012b(i, 1, n_size[0], &m_emlrtBCI, sp);
    }

    N[1] = n_data[(i + n_size[0]) - 1];
    if (!((i >= 1) && (i <= n_size[0]))) {
      emlrtDynamicBoundsCheckR2012b(i, 1, n_size[0], &n_emlrtBCI, sp);
    }

    N[2] = n_data[(i + (n_size[0] << 1)) - 1];
    i0 = (i - 1) + 1;
    if (!((i0 >= 1) && (i0 <= Voo_vec_size_idx_0))) {
      emlrtDynamicBoundsCheckR2012b(i0, 1, Voo_vec_size_idx_0, &k_emlrtBCI, sp);
    }

    y = 0.0;
    for (c_loop_ub = 0; c_loop_ub < 3; c_loop_ub++) {
      y += Voo_vec_data[(i + Voo_vec_size_idx_0 * c_loop_ub) - 1] * N[c_loop_ub];
    }

    i0 = G->size[0];
    if (!((i >= 1) && (i <= i0))) {
      emlrtDynamicBoundsCheckR2012b(i, 1, i0, &o_emlrtBCI, sp);
    }

    G->data[i - 1] = -y;
    i++;
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }
  }

  emxInit_real_T2(sp, &x, 1, &emlrtRTEI, true);

  /*  CIRCULACAO */
  /*  --------------------------------- */
  st.site = &e_emlrtRSI;
  linsolve(&st, w, G);

  /*  CALCULO DAS FORCAS */
  /*  --------------------------------- */
  /*  L_sec = rho*Voo*G;s */
  /*  cl = 2*L_sec./(rho.*c*Voo^2); */
  i0 = x->size[0];
  x->size[0] = G->size[0];
  emxEnsureCapacity(sp, (emxArray__common *)x, i0, sizeof(real_T), &emlrtRTEI);
  loop_ub = G->size[0];
  emxFree_real_T(&w);
  for (i0 = 0; i0 < loop_ub; i0++) {
    x->data[i0] = 2.0 * G->data[i0];
  }

  st.site = &f_emlrtRSI;
  cl_size[0] = c_size[0];
  loop_ub = c_size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    cl_data[i0] = Voo * c_data[i0];
  }

  varargin_1[0] = x->size[0];
  varargin_1[1] = 1;
  varargin_2[0] = (int16_T)cl_size[0];
  varargin_2[1] = 1;
  p = false;
  b_p = true;
  c_loop_ub = 0;
  exitg1 = false;
  while ((!exitg1) && (c_loop_ub < 2)) {
    if (!(varargin_1[c_loop_ub] == varargin_2[c_loop_ub])) {
      b_p = false;
      exitg1 = true;
    } else {
      c_loop_ub++;
    }
  }

  if (b_p) {
    p = true;
  }

  if (!p) {
    emlrtErrorWithMessageIdR2012b(&st, &p_emlrtRTEI, "MATLAB:dimagree", 0);
  }

  cl_size[0] = x->size[0];
  loop_ub = x->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    cl_data[i0] = x->data[i0] / cl_data[i0];
  }

  emxFree_real_T(&x);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (SOLVER_LINEAR_VLM.c) */
