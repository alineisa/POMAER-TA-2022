/*
 * VORTEX_INDUCED.c
 *
 * Code generation for function 'VORTEX_INDUCED'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "VORTEX_INDUCED.h"
#include "VORTEX_INDUCED_emxutil.h"
#include "eml_int_forloop_overflow_check.h"
#include "norm.h"
#include "VORTEX_INDUCED_data.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 103,   /* lineNo */
  "VORTEX_INDUCED",                    /* fcnName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\VORTEX_INDUCED.m"/* pathName */
};

static emlrtRSInfo b_emlrtRSI = { 9,   /* lineNo */
  "sum",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\eml\\lib\\matlab\\datafun\\sum.m"/* pathName */
};

static emlrtRSInfo c_emlrtRSI = { 58,  /* lineNo */
  "sumprod",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\eml\\lib\\matlab\\datafun\\private\\sumprod.m"/* pathName */
};

static emlrtRSInfo d_emlrtRSI = { 114, /* lineNo */
  "combine_vector_elements",           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\eml\\lib\\matlab\\datafun\\private\\combine_vector_elements.m"/* pathName */
};

static emlrtRSInfo e_emlrtRSI = { 20,  /* lineNo */
  "eml_int_forloop_overflow_check",    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\eml\\lib\\matlab\\eml\\eml_int_forloop_overflow_check.m"/* pathName */
};

static emlrtRTEInfo emlrtRTEI = { 1,   /* lineNo */
  19,                                  /* colNo */
  "VORTEX_INDUCED",                    /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\VORTEX_INDUCED.m"/* pName */
};

static emlrtRTEInfo b_emlrtRTEI = { 60,/* lineNo */
  1,                                   /* colNo */
  "VORTEX_INDUCED",                    /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\VORTEX_INDUCED.m"/* pName */
};

static emlrtDCInfo emlrtDCI = { 61,    /* lineNo */
  8,                                   /* colNo */
  "VORTEX_INDUCED",                    /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\VORTEX_INDUCED.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo emlrtBCI = { -1,    /* iFirst */
  -1,                                  /* iLast */
  72,                                  /* lineNo */
  21,                                  /* colNo */
  "Vortex",                            /* aName */
  "VORTEX_INDUCED",                    /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\VORTEX_INDUCED.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo b_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  73,                                  /* lineNo */
  21,                                  /* colNo */
  "Vortex",                            /* aName */
  "VORTEX_INDUCED",                    /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\VORTEX_INDUCED.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo c_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  89,                                  /* lineNo */
  13,                                  /* colNo */
  "Vind_k",                            /* aName */
  "VORTEX_INDUCED",                    /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\VORTEX_INDUCED.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo d_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  93,                                  /* lineNo */
  13,                                  /* colNo */
  "Vind_k",                            /* aName */
  "VORTEX_INDUCED",                    /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\VORTEX_INDUCED.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo e_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  96,                                  /* lineNo */
  12,                                  /* colNo */
  "Vind_k",                            /* aName */
  "VORTEX_INDUCED",                    /* fName */
  "D:\\GoogleDrive_Andre\\VANT\\00-MACACO\\02-aerodinamica\\04-NL_VLM\\VORTEX_INDUCED.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo d_emlrtRTEI = { 20,/* lineNo */
  15,                                  /* colNo */
  "sumprod",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\eml\\lib\\matlab\\datafun\\private\\sumprod.m"/* pName */
};

static emlrtRTEInfo e_emlrtRTEI = { 48,/* lineNo */
  9,                                   /* colNo */
  "sumprod",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\eml\\lib\\matlab\\datafun\\private\\sumprod.m"/* pName */
};

/* Function Definitions */
void VORTEX_INDUCED(const emlrtStack *sp, const real_T P[3], const
                    emxArray_real_T *Vortex, real_T G, real_T tipo, real_T Vind
                    [3])
{
  emxArray_real_T *Vind_k;
  int32_T xoffset;
  int32_T i;
  int32_T vlen;
  int32_T k;
  boolean_T p;
  boolean_T b_p;
  int32_T exitg1;
  real_T r1xr2[3];
  real_T b[3];
  real_T r0[3];
  boolean_T exitg3;
  real_T s;
  real_T r1[3];
  real_T r2[3];
  real_T r1_s;
  real_T r2_s;
  boolean_T exitg2;
  real_T y;
  real_T c;
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
  emxInit_real_T(sp, &Vind_k, 2, &b_emlrtRTEI, true);

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
  /* 	^	P */
  /* 	^	* */
  /* k=1	o */
  /* 	 */
  /* +OO */
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
  xoffset = Vortex->size[1];
  i = Vind_k->size[0] * Vind_k->size[1];
  Vind_k->size[0] = xoffset;
  Vind_k->size[1] = 3;
  emxEnsureCapacity(sp, (emxArray__common *)Vind_k, i, (int32_T)sizeof(real_T),
                    &emlrtRTEI);
  vlen = xoffset * 3;
  for (i = 0; i < vlen; i++) {
    Vind_k->data[i] = 0.0;
  }

  if (tipo != (int32_T)muDoubleScalarFloor(tipo)) {
    emlrtIntegerCheckR2012b(tipo, &emlrtDCI, sp);
  }

  switch ((int32_T)tipo) {
   case 1:
    /*  		Vind_k = zeros(K,3); */
    /*  Cálculo da velocidade induzida por cada segmento do vórtice */
    k = 0;
    while (k <= xoffset - 2) {
      i = Vortex->size[1];
      vlen = k + 1;
      if (!((vlen >= 1) && (vlen <= i))) {
        emlrtDynamicBoundsCheckR2012b(vlen, 1, i, &emlrtBCI, sp);
      }

      i = Vortex->size[1];
      vlen = (int32_T)((1.0 + (real_T)k) + 1.0);
      if (!((vlen >= 1) && (vlen <= i))) {
        emlrtDynamicBoundsCheckR2012b(vlen, 1, i, &b_emlrtBCI, sp);
      }

      for (i = 0; i < 3; i++) {
        r1xr2[i] = P[i] - Vortex->data[Vortex->size[0] * k + Vortex->size[0] *
          Vortex->size[1] * i];
      }

      for (i = 0; i < 3; i++) {
        b[i] = P[i] - Vortex->data[Vortex->size[0] * (k + 1) + Vortex->size[0] *
          Vortex->size[1] * i];
      }

      r0[0] = r1xr2[1] * b[2] - r1xr2[2] * b[1];
      r0[1] = r1xr2[2] * b[0] - r1xr2[0] * b[2];
      r0[2] = r1xr2[0] * b[1] - r1xr2[1] * b[0];
      for (vlen = 0; vlen < 3; vlen++) {
        r1xr2[vlen] = muDoubleScalarAbs(r0[vlen]);
      }

      p = true;
      vlen = 0;
      exitg3 = false;
      while ((!exitg3) && (vlen < 3)) {
        if (!(r1xr2[vlen] < 1.0E-6)) {
          p = false;
          exitg3 = true;
        } else {
          vlen++;
        }
      }

      if (!p) {
        for (i = 0; i < 3; i++) {
          r0[i] = Vortex->data[Vortex->size[0] * (k + 1) + Vortex->size[0] *
            Vortex->size[1] * i] - Vortex->data[Vortex->size[0] * k +
            Vortex->size[0] * Vortex->size[1] * i];
        }

        for (i = 0; i < 3; i++) {
          r1[i] = P[i] - Vortex->data[Vortex->size[0] * k + Vortex->size[0] *
            Vortex->size[1] * i];
        }

        for (i = 0; i < 3; i++) {
          r2[i] = P[i] - Vortex->data[Vortex->size[0] * (k + 1) + Vortex->size[0]
            * Vortex->size[1] * i];
        }

        r1_s = norm(r1);
        r2_s = norm(r2);

        /*  Diâmetro do núcleo do vórtice */
        b[0] = norm(r0);
        b[1] = r1_s;
        b[2] = r2_s;
        for (vlen = 0; vlen < 3; vlen++) {
          r1xr2[vlen] = muDoubleScalarAbs(b[vlen]);
        }

        p = false;
        vlen = 0;
        exitg2 = false;
        while ((!exitg2) && (vlen < 3)) {
          if (!!(r1xr2[vlen] <= 1.0E-6)) {
            p = true;
            exitg2 = true;
          } else {
            vlen++;
          }
        }

        if (p) {
          vlen = Vind_k->size[0];
          if (!((k + 1 >= 1) && (k + 1 <= vlen))) {
            emlrtDynamicBoundsCheckR2012b(k + 1, 1, vlen, &c_emlrtBCI, sp);
          }

          for (i = 0; i < 3; i++) {
            Vind_k->data[k + Vind_k->size[0] * i] = 0.0;
          }
        } else {
          r1xr2[0] = r1[1] * r2[2] - r1[2] * r2[1];
          r1xr2[1] = r1[2] * r2[0] - r1[0] * r2[2];
          r1xr2[2] = r1[0] * r2[1] - r1[1] * r2[0];
          s = norm(r1xr2);
          y = G / 12.566370614359172;
          s *= s;
          c = 0.0;
          for (vlen = 0; vlen < 3; vlen++) {
            c += r0[vlen] * (r1[vlen] / r1_s - r2[vlen] / r2_s);
          }

          vlen = Vind_k->size[0];
          if (!((k + 1 >= 1) && (k + 1 <= vlen))) {
            emlrtDynamicBoundsCheckR2012b(k + 1, 1, vlen, &d_emlrtBCI, sp);
          }

          for (i = 0; i < 3; i++) {
            Vind_k->data[k + Vind_k->size[0] * i] = y * r1xr2[i] / s * c;
          }
        }
      } else {
        vlen = Vind_k->size[0];
        if (!((k + 1 >= 1) && (k + 1 <= vlen))) {
          emlrtDynamicBoundsCheckR2012b(k + 1, 1, vlen, &e_emlrtBCI, sp);
        }

        for (i = 0; i < 3; i++) {
          Vind_k->data[k + Vind_k->size[0] * i] = 0.0;
        }
      }

      k++;
      if (*emlrtBreakCheckR2012bFlagVar != 0) {
        emlrtBreakCheckR2012b(sp);
      }
    }
    break;
  }

  /*  Soma das velocidades induzidas por cada segmento */
  st.site = &emlrtRSI;
  b_st.site = &b_emlrtRSI;
  p = (Vind_k->size[0] != 1);
  if (!p) {
    emlrtErrorWithMessageIdR2012b(&b_st, &d_emlrtRTEI,
      "Coder:toolbox:autoDimIncompatibility", 0);
  }

  p = false;
  b_p = false;
  k = 0;
  do {
    exitg1 = 0;
    if (k < 2) {
      if (Vind_k->size[k] != 0) {
        exitg1 = 1;
      } else {
        k++;
      }
    } else {
      b_p = true;
      exitg1 = 1;
    }
  } while (exitg1 == 0);

  if (b_p) {
    p = true;
  }

  if (p) {
    emlrtErrorWithMessageIdR2012b(&b_st, &e_emlrtRTEI,
      "Coder:toolbox:UnsupportedSpecialEmpty", 0);
  }

  c_st.site = &c_emlrtRSI;
  if (Vind_k->size[0] == 0) {
    for (i = 0; i < 3; i++) {
      Vind[i] = 0.0;
    }
  } else {
    vlen = Vind_k->size[0];
    for (i = 0; i < 3; i++) {
      xoffset = i * vlen;
      s = Vind_k->data[xoffset];
      d_st.site = &d_emlrtRSI;
      if ((!(2 > vlen)) && (vlen > 2147483646)) {
        e_st.site = &e_emlrtRSI;
        check_forloop_overflow_error(&e_st);
      }

      for (k = 2; k <= vlen; k++) {
        s += Vind_k->data[(xoffset + k) - 1];
      }

      Vind[i] = s;
    }
  }

  emxFree_real_T(&Vind_k);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (VORTEX_INDUCED.c) */
