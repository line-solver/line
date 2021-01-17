/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_pfqn_amvabs_api.c
 *
 * Code generation for function '_coder_pfqn_amvabs_api'
 *
 */

/* Include files */
#include "_coder_pfqn_amvabs_api.h"
#include "pfqn_amvabs.h"
#include "pfqn_amvabs_data.h"
#include "pfqn_amvabs_emxutil.h"
#include "pfqn_amvabs_types.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRTEInfo g_emlrtRTEI = { 1, /* lineNo */
  1,                                   /* colNo */
  "_coder_pfqn_amvabs_api",            /* fName */
  ""                                   /* pName */
};

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static void b_emlrt_marshallOut(const emxArray_real_T *u, const mxArray *y);
static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *N, const
  char_T *identifier, emxArray_real_T *y);
static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static real_T e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *tol, const
  char_T *identifier);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *L, const
  char_T *identifier, emxArray_real_T *y);
static const mxArray *emlrt_marshallOut(const emxArray_real_T *u);
static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);
static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);
static real_T i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId);

/* Function Definitions */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  g_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void b_emlrt_marshallOut(const emxArray_real_T *u, const mxArray *y)
{
  emlrtMxSetData((mxArray *)y, &u->data[0]);
  emlrtSetDimensions((mxArray *)y, u->size, 2);
}

static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *N, const
  char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  d_emlrt_marshallIn(sp, emlrtAlias(N), &thisId, y);
  emlrtDestroyArray(&N);
}

static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  h_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static real_T e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *tol, const
  char_T *identifier)
{
  emlrtMsgIdentifier thisId;
  real_T y;
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = f_emlrt_marshallIn(sp, emlrtAlias(tol), &thisId);
  emlrtDestroyArray(&tol);
  return y;
}

static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *L, const
  char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  b_emlrt_marshallIn(sp, emlrtAlias(L), &thisId, y);
  emlrtDestroyArray(&L);
}

static const mxArray *emlrt_marshallOut(const emxArray_real_T *u)
{
  static const int32_T iv[2] = { 0, 0 };

  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateNumericArray(2, &iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, &u->data[0]);
  emlrtSetDimensions((mxArray *)m, u->size, 2);
  emlrtAssign(&y, m);
  return y;
}

static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = i_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  static const int32_T dims[2] = { -1, -1 };

  int32_T iv[2];
  int32_T i;
  const boolean_T bv[2] = { true, true };

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims, &bv[0],
    iv);
  ret->allocatedSize = iv[0] * iv[1];
  i = ret->size[0] * ret->size[1];
  ret->size[0] = iv[0];
  ret->size[1] = iv[1];
  emxEnsureCapacity_real_T(sp, ret, i, (emlrtRTEInfo *)NULL);
  ret->data = (real_T *)emlrtMxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  static const int32_T dims[2] = { 1, -1 };

  int32_T iv[2];
  int32_T i;
  const boolean_T bv[2] = { false, true };

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims, &bv[0],
    iv);
  ret->allocatedSize = iv[0] * iv[1];
  i = ret->size[0] * ret->size[1];
  ret->size[0] = iv[0];
  ret->size[1] = iv[1];
  emxEnsureCapacity_real_T(sp, ret, i, (emlrtRTEInfo *)NULL);
  ret->data = (real_T *)emlrtMxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static real_T i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId)
{
  static const int32_T dims = 0;
  real_T ret;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 0U, &dims);
  ret = *(real_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

void pfqn_amvabs_api(const mxArray * const prhs[7], int32_T nlhs, const mxArray *
                     plhs[3])
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  emxArray_real_T *L;
  emxArray_real_T *N;
  emxArray_real_T *QN;
  emxArray_real_T *UN;
  emxArray_real_T *XN;
  emxArray_real_T *Z;
  emxArray_real_T *weight;
  const mxArray *prhs_copy_idx_5;
  real_T maxiter;
  real_T tol;
  st.tls = emlrtRootTLSGlobal;
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  emxInit_real_T(&st, &L, 2, &g_emlrtRTEI, true);
  emxInit_real_T(&st, &N, 2, &g_emlrtRTEI, true);
  emxInit_real_T(&st, &Z, 2, &g_emlrtRTEI, true);
  emxInit_real_T(&st, &QN, 2, &g_emlrtRTEI, true);
  emxInit_real_T(&st, &weight, 2, &g_emlrtRTEI, true);
  emxInit_real_T(&st, &XN, 2, &g_emlrtRTEI, true);
  emxInit_real_T(&st, &UN, 2, &g_emlrtRTEI, true);
  prhs_copy_idx_5 = emlrtProtectR2012b(prhs[5], 5, true, -1);

  /* Marshall function inputs */
  L->canFreeData = false;
  emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "L", L);
  N->canFreeData = false;
  c_emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "N", N);
  Z->canFreeData = false;
  c_emlrt_marshallIn(&st, emlrtAlias(prhs[2]), "Z", Z);
  tol = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[3]), "tol");
  maxiter = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[4]), "maxiter");
  QN->canFreeData = false;
  emlrt_marshallIn(&st, emlrtAlias(prhs_copy_idx_5), "QN", QN);
  weight->canFreeData = false;
  emlrt_marshallIn(&st, emlrtAlias(prhs[6]), "weight", weight);

  /* Invoke the target function */
  pfqn_amvabs(&st, L, N, Z, tol, maxiter, QN, weight, XN, UN);

  /* Marshall function outputs */
  XN->canFreeData = false;
  plhs[0] = emlrt_marshallOut(XN);
  emxFree_real_T(&XN);
  emxFree_real_T(&weight);
  emxFree_real_T(&Z);
  emxFree_real_T(&N);
  emxFree_real_T(&L);
  if (nlhs > 1) {
    QN->canFreeData = false;
    b_emlrt_marshallOut(QN, prhs_copy_idx_5);
    plhs[1] = prhs_copy_idx_5;
  }

  emxFree_real_T(&QN);
  if (nlhs > 2) {
    UN->canFreeData = false;
    plhs[2] = emlrt_marshallOut(UN);
  }

  emxFree_real_T(&UN);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

/* End of code generation (_coder_pfqn_amvabs_api.c) */