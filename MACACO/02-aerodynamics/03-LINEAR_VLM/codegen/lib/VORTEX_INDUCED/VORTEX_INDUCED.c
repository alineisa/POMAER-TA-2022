/*
 * File: VORTEX_INDUCED.c
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 19-Aug-2018 14:58:07
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "VORTEX_INDUCED.h"
#include "norm.h"
#include "VORTEX_INDUCED_emxutil.h"

/* Function Definitions */

/*
 * {
 *
 * Função responsável por calcular a velocidade em um ponto P devido a um
 * Vortice de intensidade G.
 *
 * Vortex( 1:k    , 1:3  )
 *   k-ésimo vértice  coordenadas
 *   do vortice   x,y,z
 *
 *
 *
 * Exemplo de vórtice linear (tipo = 0)
 *
 * -OO
 *
 * k=2 o
 *  ^
 *  ^
 *  ^
 *  ^ P
 *  ^ *
 * k=1 o
 *
 * +OO
 *
 *
 * Exemplo de vórtice ferradura (tipo = 1)
 *
 * k=3 o > > > o k=4
 *  ^  v
 *  ^  v
 *  ^  v
 *  ^ P v
 *  ^ * v
 * k=2 o  o k=5
 *     ^  v
 *     ^  v
 *     ^  v
 *     ^  v
 * k=1 o       o k=6
 *
 * +OO          +OO
 *
 *
 *
 * Exemplo de vórtice anel (tipo = 2)
 *
 * k=2 o > > > o k=3
 *  ^  v
 *  ^  v
 *  ^ P v
 *  ^ * v
 *  ^  v
 * k=1 o < < < o k=4
 *
 * }
 * Arguments    : const double P[3]
 *                const emxArray_real_T *Vortex
 *                double G
 *                double tipo
 *                double Vind[3]
 * Return Type  : void
 */
void VORTEX_INDUCED(const double P[3], const emxArray_real_T *Vortex, double G,
                    double tipo, double Vind[3])
{
  emxArray_real_T *Vind_k;
  int xoffset;
  int i;
  int vlen;
  int k;
  double s;
  double r0[3];
  double r1[3];
  double r1_s;
  double r2[3];
  double r2_s;
  double r1xr2[3];
  boolean_T y;
  double b_y[3];
  boolean_T exitg1;
  double c_y;
  double c;
  emxInit_real_T(&Vind_k, 2);
  xoffset = Vortex->size[1];
  i = Vind_k->size[0] * Vind_k->size[1];
  Vind_k->size[0] = xoffset;
  Vind_k->size[1] = 3;
  emxEnsureCapacity((emxArray__common *)Vind_k, i, sizeof(double));
  vlen = xoffset * 3;
  for (i = 0; i < vlen; i++) {
    Vind_k->data[i] = 0.0;
  }

  switch ((int)tipo) {
   case 1:
    /*  		Vind_k = zeros(K,3); */
    /*  Cálculo da velocidade induzida por cada segmento do vórtice */
    for (k = 0; k <= xoffset - 2; k++) {
      for (i = 0; i < 3; i++) {
        r0[i] = Vortex->data[Vortex->size[0] * (k + 1) + Vortex->size[0] *
          Vortex->size[1] * i] - Vortex->data[Vortex->size[0] * k + Vortex->
          size[0] * Vortex->size[1] * i];
      }

      for (i = 0; i < 3; i++) {
        r1[i] = P[i] - Vortex->data[Vortex->size[0] * k + Vortex->size[0] *
          Vortex->size[1] * i];
      }

      for (i = 0; i < 3; i++) {
        r2[i] = P[i] - Vortex->data[Vortex->size[0] * (k + 1) + Vortex->size[0] *
          Vortex->size[1] * i];
      }

      r1_s = norm(r1);
      r2_s = norm(r2);

      /*  Diâmetro do núcleo do vórtice */
      r1xr2[0] = norm(r0);
      r1xr2[1] = r1_s;
      r1xr2[2] = r2_s;
      for (vlen = 0; vlen < 3; vlen++) {
        b_y[vlen] = fabs(r1xr2[vlen]);
      }

      y = false;
      vlen = 0;
      exitg1 = false;
      while ((!exitg1) && (vlen < 3)) {
        if (b_y[vlen] <= 1.0E-9) {
          y = true;
          exitg1 = true;
        } else {
          vlen++;
        }
      }

      if (y) {
        for (i = 0; i < 3; i++) {
          Vind_k->data[k + Vind_k->size[0] * i] = 0.0;
        }
      } else {
        r1xr2[0] = r1[1] * r2[2] - r1[2] * r2[1];
        r1xr2[1] = r1[2] * r2[0] - r1[0] * r2[2];
        r1xr2[2] = r1[0] * r2[1] - r1[1] * r2[0];
        s = norm(r1xr2);
        c_y = G / 12.566370614359172;
        s *= s;
        c = 0.0;
        for (vlen = 0; vlen < 3; vlen++) {
          c += r0[vlen] * (r1[vlen] / r1_s - r2[vlen] / r2_s);
        }

        for (i = 0; i < 3; i++) {
          Vind_k->data[k + Vind_k->size[0] * i] = c_y * r1xr2[i] / s * c;
        }
      }
    }
    break;
  }

  /*  Soma das velocidades induzidas por cada segmento */
  if (Vind_k->size[0] == 0) {
    for (i = 0; i < 3; i++) {
      Vind[i] = 0.0;
    }
  } else {
    vlen = Vind_k->size[0];
    for (i = 0; i < 3; i++) {
      xoffset = i * vlen;
      s = Vind_k->data[xoffset];
      for (k = 2; k <= vlen; k++) {
        s += Vind_k->data[(xoffset + k) - 1];
      }

      Vind[i] = s;
    }
  }

  emxFree_real_T(&Vind_k);
}

/*
 * File trailer for VORTEX_INDUCED.c
 *
 * [EOF]
 */
