/*
 * SOLVER_LINEAR_VLM.h
 *
 * Code generation for function 'SOLVER_LINEAR_VLM'
 *
 */

#ifndef SOLVER_LINEAR_VLM_H
#define SOLVER_LINEAR_VLM_H

/* Include files */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mwmathutil.h"
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "SOLVER_LINEAR_VLM_types.h"

/* Function Declarations */
extern void SOLVER_LINEAR_VLM(const emlrtStack *sp, real_T nmesh, real_T
  IsSymSimulation, real_T IsSymSimulation_factor, const real_T PC34_data[],
  const int32_T PC34_size[2], const real_T c_data[], const int32_T c_size[1],
  const emxArray_real_T *Vort, const real_T n_data[], const int32_T n_size[2],
  const real_T alpha_data[], const int32_T alpha_size[1], const real_T
  beta_data[], const int32_T beta_size[1], real_T Voo, emxArray_real_T *G,
  real_T cl_data[], int32_T cl_size[1]);

#endif

/* End of code generation (SOLVER_LINEAR_VLM.h) */
