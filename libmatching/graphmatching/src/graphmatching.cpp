//
// MATLAB Compiler: 4.9 (R2008b)
// Date: Tue Feb 24 19:45:30 2015
// Arguments: "-B" "macro_default" "-W" "cpplib:graphmatching" "-d"
// "D:\bitbacket\phd_codesourse\libmatching\graphmatching\src" "-T" "link:lib"
// "-v" "D:\bitbacket\phd_codesourse\libmatching\matchingGraphs.m" 
//

#include <stdio.h>
#define EXPORTING_graphmatching 1
#include "graphmatching.h"
#ifdef __cplusplus
extern "C" {
#endif

extern mclComponentData __MCC_graphmatching_component_data;

#ifdef __cplusplus
}
#endif


static HMCRINSTANCE _mcr_inst = NULL;


#if defined( _MSC_VER) || defined(__BORLANDC__) || defined(__WATCOMC__) || defined(__LCC__)
#ifdef __LCC__
#undef EXTERN_C
#endif
#include <windows.h>

static char path_to_dll[_MAX_PATH];

BOOL WINAPI DllMain(HINSTANCE hInstance, DWORD dwReason, void *pv)
{
    if (dwReason == DLL_PROCESS_ATTACH)
    {
        if (GetModuleFileName(hInstance, path_to_dll, _MAX_PATH) == 0)
            return FALSE;
    }
    else if (dwReason == DLL_PROCESS_DETACH)
    {
    }
    return TRUE;
}
#endif
#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultPrintHandler(const char *s)
{
  return mclWrite(1 /* stdout */, s, sizeof(char)*strlen(s));
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultErrorHandler(const char *s)
{
  int written = 0;
  size_t len = 0;
  len = strlen(s);
  written = mclWrite(2 /* stderr */, s, sizeof(char)*len);
  if (len > 0 && s[ len-1 ] != '\n')
    written += mclWrite(2 /* stderr */, "\n", sizeof(char));
  return written;
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_graphmatching_C_API 
#define LIB_graphmatching_C_API /* No special import/export declaration */
#endif

LIB_graphmatching_C_API 
bool MW_CALL_CONV graphmatchingInitializeWithHandlers(
    mclOutputHandlerFcn error_handler,
    mclOutputHandlerFcn print_handler
)
{
  if (_mcr_inst != NULL)
    return true;
  if (!mclmcrInitialize())
    return false;
  if (!GetModuleFileName(GetModuleHandle("graphmatching"), path_to_dll, _MAX_PATH))
    return false;
  if (!mclInitializeComponentInstanceWithEmbeddedCTF(&_mcr_inst,
                                                     &__MCC_graphmatching_component_data,
                                                     true, NoObjectType,
                                                     LibTarget, error_handler,
                                                     print_handler, 1299993, path_to_dll))
    return false;
  return true;
}

LIB_graphmatching_C_API 
bool MW_CALL_CONV graphmatchingInitialize(void)
{
  return graphmatchingInitializeWithHandlers(mclDefaultErrorHandler,
                                             mclDefaultPrintHandler);
}

LIB_graphmatching_C_API 
void MW_CALL_CONV graphmatchingTerminate(void)
{
  if (_mcr_inst != NULL)
    mclTerminateInstance(&_mcr_inst);
}

LIB_graphmatching_C_API 
long MW_CALL_CONV graphmatchingGetMcrID() 
{
  return mclGetID(_mcr_inst);
}

LIB_graphmatching_C_API 
void MW_CALL_CONV graphmatchingPrintStackTrace(void) 
{
  char** stackTrace;
  int stackDepth = mclGetStackTrace(_mcr_inst, &stackTrace);
  int i;
  for(i=0; i<stackDepth; i++)
  {
    mclWrite(2 /* stderr */, stackTrace[i], sizeof(char)*strlen(stackTrace[i]));
    mclWrite(2 /* stderr */, "\n", sizeof(char)*strlen("\n"));
  }
  mclFreeStackTrace(&stackTrace, stackDepth);
}


LIB_graphmatching_C_API 
bool MW_CALL_CONV mlxMatchingGraphs(int nlhs, mxArray *plhs[],
                                    int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "matchingGraphs", nlhs, plhs, nrhs, prhs);
}

LIB_graphmatching_CPP_API 
void MW_CALL_CONV matchingGraphs(int nargout, mwArray& score
                                 , const mwArray& G1, const mwArray& W1
                                 , const mwArray& G2, const mwArray& W2)
{
  mclcppMlfFeval(_mcr_inst, "matchingGraphs", nargout,
                 1, 4, &score, &G1, &W1, &G2, &W2);
}
