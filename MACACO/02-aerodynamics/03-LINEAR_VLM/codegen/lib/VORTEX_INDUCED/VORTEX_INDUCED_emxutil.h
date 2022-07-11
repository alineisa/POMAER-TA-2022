/*
 * File: VORTEX_INDUCED_emxutil.h
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 19-Aug-2018 14:58:07
 */

#ifndef VORTEX_INDUCED_EMXUTIL_H
#define VORTEX_INDUCED_EMXUTIL_H

/* Include Files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "rtwtypes.h"
#include "VORTEX_INDUCED_types.h"

/* Function Declarations */
extern void emxEnsureCapacity(emxArray__common *emxArray, int oldNumel, unsigned
  int elementSize);
extern void emxFree_real_T(emxArray_real_T **pEmxArray);
extern void emxInit_real_T(emxArray_real_T **pEmxArray, int numDimensions);
extern void emxInit_real_T1(emxArray_real_T **pEmxArray, int numDimensions);

#endif

/*
 * File trailer for VORTEX_INDUCED_emxutil.h
 *
 * [EOF]
 */
