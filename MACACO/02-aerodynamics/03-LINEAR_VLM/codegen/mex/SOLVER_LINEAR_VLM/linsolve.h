/*
 * linsolve.h
 *
 * Code generation for function 'linsolve'
 *
 */

#ifndef LINSOLVE_H
#define LINSOLVE_H

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
extern void linsolve(const emlrtStack *sp, const emxArray_real_T *A,
                     emxArray_real_T *B);

#endif

/* End of code generation (linsolve.h) */
