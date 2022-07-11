/*
 * VORTEX_INDUCED.c
 *
 * Code generation for function 'VORTEX_INDUCED'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "SOLVER_LINEAR_VLM.h"
#include "VORTEX_INDUCED.h"
#include "norm.h"
#include "SOLVER_LINEAR_VLM_data.h"

/* Variable Definitions */
static emlrtRSInfo g_emlrtRSI = { 100, /* lineNo */
  "VORTEX_INDUCED",                    /* fcnName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\VORTEX_INDUCED.m"/* pathName */
};

static emlrtRSInfo h_emlrtRSI = { 9,   /* lineNo */
  "sum",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\lib\\matlab\\datafun\\sum.m"/* pathName */
};

static emlrtRTEInfo q_emlrtRTEI = { 20,/* lineNo */
  15,                                  /* colNo */
  "sumprod",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2017a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\sumprod.m"/* pName */
};

static emlrtBCInfo bb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  91,                                  /* lineNo */
  12,                                  /* colNo */
  "Vind_k",                            /* aName */
  "VORTEX_INDUCED",                    /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\VORTEX_INDUCED.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo cb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  86,                                  /* lineNo */
  12,                                  /* colNo */
  "Vind_k",                            /* aName */
  "VORTEX_INDUCED",                    /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\VORTEX_INDUCED.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo db_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  73,                                  /* lineNo */
  21,                                  /* colNo */
  "Vortex",                            /* aName */
  "VORTEX_INDUCED",                    /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\VORTEX_INDUCED.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo eb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  72,                                  /* lineNo */
  21,                                  /* colNo */
  "Vortex",                            /* aName */
  "VORTEX_INDUCED",                    /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\VORTEX_INDUCED.m",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void VORTEX_INDUCED(const emlrtStack *sp, const real_T P[3], const real_T
                    Vortex_data[], const int32_T Vortex_size[3], real_T Vind[3])
{
  int32_T varargin_2;
  int32_T Vind_k_size_idx_0;
  int32_T loop_ub;
  int32_T xoffset;
  real_T Vind_k_data[300];
  int32_T k;
  real_T r1_s;
  real_T r1[3];
  real_T r0[3];
  real_T r2_s;
  real_T r2[3];
  real_T s;
  real_T r1xr2[3];
  boolean_T y;
  real_T b_y[3];
  boolean_T exitg1;
  real_T c;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;

  /* { */
  /*  */
  /* Função responsável por calcular a velocidade em um ponto P devido a um */
  /* Vortice de intensidade G. */
  /*  */
  /* Vortex(	1:k				,	1:3		) */
  /* 		k-ésimo vértice		coordenadas */
  /* 		do vortice			x,y,z */
  /*  */
  /*  */
  /*  */
  /* Exemplo de vórtice linear (tipo = 0) */
  /*  */
  /* -OO */
  /*  */
  /* k=2	o */
  /* 	^ */
  /* 	^ */
  /* 	^ */
  /* 	^	P	 */
  /* 	^	*	 */
  /* k=1	o	 */
  /* 	 */
  /* +OO          */
  /*  */
  /*  */
  /* Exemplo de vórtice ferradura (tipo = 1) */
  /*  */
  /* k=3	o > > > o k=4 */
  /* 	^		v */
  /* 	^		v */
  /* 	^		v */
  /* 	^	P	v */
  /* 	^	*	v */
  /* k=2	o		o k=5 */
  /*     ^		v */
  /*     ^		v */
  /*     ^		v */
  /*     ^		v */
  /* k=1	o       o k=6 */
  /*  */
  /* +OO          +OO */
  /*  */
  /*  */
  /*  */
  /* Exemplo de vórtice anel (tipo = 2) */
  /*  */
  /* k=2	o > > > o k=3 */
  /* 	^		v */
  /* 	^		v */
  /* 	^	P	v */
  /* 	^	*	v */
  /* 	^		v */
  /* k=1	o < < < o k=4 */
  /*          */
  /* } */
  varargin_2 = Vortex_size[1];
  Vind_k_size_idx_0 = Vortex_size[1];
  loop_ub = Vortex_size[1] * 3;
  for (xoffset = 0; xoffset < loop_ub; xoffset++) {
    Vind_k_data[xoffset] = 0.0;
  }

  /*  		Vind_k = zeros(K,3); */
  /*  Cálculo da velocidade induzida por cada segmento do vórtice */
  k = 0;
  while (k <= varargin_2 - 2) {
    xoffset = k + 1;
    if (!((xoffset >= 1) && (xoffset <= Vortex_size[1]))) {
      emlrtDynamicBoundsCheckR2012b(xoffset, 1, Vortex_size[1], &eb_emlrtBCI, sp);
    }

    xoffset = (int32_T)((1.0 + (real_T)k) + 1.0);
    if (!((xoffset >= 1) && (xoffset <= Vortex_size[1]))) {
      emlrtDynamicBoundsCheckR2012b(xoffset, 1, Vortex_size[1], &db_emlrtBCI, sp);
    }

    for (xoffset = 0; xoffset < 3; xoffset++) {
      r0[xoffset] = Vortex_data[Vortex_size[0] * (k + 1) + Vortex_size[0] *
        Vortex_size[1] * xoffset] - Vortex_data[Vortex_size[0] * k +
        Vortex_size[0] * Vortex_size[1] * xoffset];
      r1[xoffset] = P[xoffset] - Vortex_data[Vortex_size[0] * k + Vortex_size[0]
        * Vortex_size[1] * xoffset];
      r2[xoffset] = P[xoffset] - Vortex_data[Vortex_size[0] * (k + 1) +
        Vortex_size[0] * Vortex_size[1] * xoffset];
    }

    r1_s = norm(r1);
    r2_s = norm(r2);

    /*  Diâmetro do núcleo do vórtice */
    r1xr2[0] = norm(r0);
    r1xr2[1] = r1_s;
    r1xr2[2] = r2_s;
    for (loop_ub = 0; loop_ub < 3; loop_ub++) {
      b_y[loop_ub] = muDoubleScalarAbs(r1xr2[loop_ub]);
    }

    y = false;
    loop_ub = 0;
    exitg1 = false;
    while ((!exitg1) && (loop_ub < 3)) {
      if (b_y[loop_ub] <= 1.0E-9) {
        y = true;
        exitg1 = true;
      } else {
        loop_ub++;
      }
    }

    if (y) {
      xoffset = 1 + k;
      if (!((xoffset >= 1) && (xoffset <= Vind_k_size_idx_0))) {
        emlrtDynamicBoundsCheckR2012b(xoffset, 1, Vind_k_size_idx_0,
          &cb_emlrtBCI, sp);
      }

      for (xoffset = 0; xoffset < 3; xoffset++) {
        Vind_k_data[k + varargin_2 * xoffset] = 0.0;
      }
    } else {
      r1xr2[0] = r1[1] * r2[2] - r1[2] * r2[1];
      r1xr2[1] = r1[2] * r2[0] - r1[0] * r2[2];
      r1xr2[2] = r1[0] * r2[1] - r1[1] * r2[0];
      s = norm(r1xr2);
      s *= s;
      c = 0.0;
      for (loop_ub = 0; loop_ub < 3; loop_ub++) {
        c += r0[loop_ub] * (r1[loop_ub] / r1_s - r2[loop_ub] / r2_s);
      }

      xoffset = 1 + k;
      if (!((xoffset >= 1) && (xoffset <= Vind_k_size_idx_0))) {
        emlrtDynamicBoundsCheckR2012b(xoffset, 1, Vind_k_size_idx_0,
          &bb_emlrtBCI, sp);
      }

      for (xoffset = 0; xoffset < 3; xoffset++) {
        Vind_k_data[k + varargin_2 * xoffset] = 0.079577471545947673 *
          r1xr2[xoffset] / s * c;
      }
    }

    k++;
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }
  }

  /*  Soma das velocidades induzidas por cada segmento */
  st.site = &g_emlrtRSI;
  b_st.site = &h_emlrtRSI;
  if (Vortex_size[1] == 1) {
    emlrtErrorWithMessageIdR2012b(&b_st, &q_emlrtRTEI,
      "Coder:toolbox:autoDimIncompatibility", 0);
  }

  if (Vortex_size[1] == 0) {
    for (xoffset = 0; xoffset < 3; xoffset++) {
      Vind[xoffset] = 0.0;
    }
  } else {
    for (loop_ub = 0; loop_ub < 3; loop_ub++) {
      xoffset = loop_ub * varargin_2;
      s = Vind_k_data[xoffset];
      for (k = 2; k <= varargin_2; k++) {
        s += Vind_k_data[(xoffset + k) - 1];
      }

      Vind[loop_ub] = s;
    }
  }
}

/* End of code generation (VORTEX_INDUCED.c) */
