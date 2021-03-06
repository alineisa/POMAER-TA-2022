/*
 * File: main.c
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 19-Aug-2018 14:58:07
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/
/* Include Files */
#include "rt_nonfinite.h"
#include "VORTEX_INDUCED.h"
#include "main.h"
#include "VORTEX_INDUCED_terminate.h"
#include "VORTEX_INDUCED_emxAPI.h"
#include "VORTEX_INDUCED_initialize.h"

/* Function Declarations */
static void argInit_1x3_real_T(double result[3]);
static emxArray_real_T *argInit_1xUnboundedx3_real_T(void);
static double argInit_real_T(void);
static void main_VORTEX_INDUCED(void);

/* Function Definitions */

/*
 * Arguments    : double result[3]
 * Return Type  : void
 */
static void argInit_1x3_real_T(double result[3])
{
  int idx1;

  /* Loop over the array to initialize each element. */
  for (idx1 = 0; idx1 < 3; idx1++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    result[idx1] = argInit_real_T();
  }
}

/*
 * Arguments    : void
 * Return Type  : emxArray_real_T *
 */
static emxArray_real_T *argInit_1xUnboundedx3_real_T(void)
{
  emxArray_real_T *result;
  static int iv0[3] = { 1, 2, 3 };

  int idx1;
  int idx2;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result = emxCreateND_real_T(3, iv0);

  /* Loop over the array to initialize each element. */
  for (idx1 = 0; idx1 < result->size[1U]; idx1++) {
    for (idx2 = 0; idx2 < 3; idx2++) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result->data[result->size[0] * idx1 + result->size[0] * result->size[1] *
        idx2] = argInit_real_T();
    }
  }

  return result;
}

/*
 * Arguments    : void
 * Return Type  : double
 */
static double argInit_real_T(void)
{
  return 0.0;
}

/*
 * Arguments    : void
 * Return Type  : void
 */
static void main_VORTEX_INDUCED(void)
{
  double P[3];
  emxArray_real_T *Vortex;
  double Vind[3];

  /* Initialize function 'VORTEX_INDUCED' input arguments. */
  /* Initialize function input argument 'P'. */
  argInit_1x3_real_T(P);

  /* Initialize function input argument 'Vortex'. */
  Vortex = argInit_1xUnboundedx3_real_T();

  /* Call the entry-point 'VORTEX_INDUCED'. */
  VORTEX_INDUCED(P, Vortex, argInit_real_T(), argInit_real_T(), Vind);
  emxDestroyArray_real_T(Vortex);
}

/*
 * Arguments    : int argc
 *                const char * const argv[]
 * Return Type  : int
 */
int main(int argc, const char * const argv[])
{
  (void)argc;
  (void)argv;

  /* Initialize the application.
     You do not need to do this more than one time. */
  VORTEX_INDUCED_initialize();

  /* Invoke the entry-point functions.
     You can call entry-point functions multiple times. */
  main_VORTEX_INDUCED();

  /* Terminate the application.
     You do not need to do this more than one time. */
  VORTEX_INDUCED_terminate();
  return 0;
}

/*
 * File trailer for main.c
 *
 * [EOF]
 */
