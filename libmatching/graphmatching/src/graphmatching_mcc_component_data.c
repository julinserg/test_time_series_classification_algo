//
// MATLAB Compiler: 4.9 (R2008b)
// Date: Tue Feb 24 19:45:30 2015
// Arguments: "-B" "macro_default" "-W" "cpplib:graphmatching" "-d"
// "D:\bitbacket\phd_codesourse\libmatching\graphmatching\src" "-T" "link:lib"
// "-v" "D:\bitbacket\phd_codesourse\libmatching\matchingGraphs.m" 
//

#include "mclmcrrt.h"

#ifdef __cplusplus
extern "C" {
#endif
extern const unsigned char __MCC_graphmatching_session_key[] = {
    'B', 'C', 'A', '8', '3', 'B', '7', '2', '6', 'B', '7', '3', '2', '1', '7',
    'B', '2', '9', 'E', '1', 'E', '0', 'D', '9', 'E', '5', '3', '2', '6', 'A',
    'B', 'C', '2', '4', '6', 'E', '3', 'C', 'C', 'D', 'F', '0', '7', 'F', '1',
    '6', 'F', '2', '2', '6', '5', 'E', '8', '3', '5', '9', '4', 'F', '6', 'E',
    'F', 'A', '2', '4', '6', '4', '1', 'C', '3', '6', '0', '4', '6', '7', '3',
    '4', '9', '7', 'A', '3', '3', 'D', '9', '4', 'F', '1', '4', 'F', 'B', '5',
    'F', '7', '2', '7', 'E', 'D', 'A', '5', '7', '3', 'A', '3', 'D', '4', 'F',
    '3', '0', '4', '0', '7', 'D', '8', '8', 'C', 'E', '6', 'C', '8', '8', '6',
    '5', '0', '0', '0', 'F', '2', '2', '9', 'B', '6', '7', '0', 'B', 'D', 'A',
    '5', 'F', '3', '8', '8', '1', '8', '5', 'B', '2', '6', 'F', 'C', 'F', 'D',
    '7', 'C', '3', '5', '5', '1', '2', '4', 'C', '1', '2', '0', 'C', '6', 'D',
    '2', '0', '2', 'B', '4', '9', 'C', '9', '2', '1', '6', '6', '1', '0', '2',
    'F', '0', 'B', '1', '0', 'D', 'A', 'C', '2', 'F', '2', 'A', '6', 'F', '2',
    'A', 'E', '7', '0', 'D', 'C', 'F', '9', '5', '5', '3', '5', '2', '4', '0',
    '3', 'B', '5', '0', '5', '4', '3', '4', '5', '1', '8', '8', '6', 'E', '1',
    '9', '8', 'D', 'C', 'A', '2', '6', 'A', 'C', '0', 'E', '2', 'D', '4', '3',
    '0', '4', '5', '6', '7', '3', 'A', 'B', '4', '5', '3', '4', 'A', 'D', '5',
    '3', '\0'};

extern const unsigned char __MCC_graphmatching_public_key[] = {
    '3', '0', '8', '1', '9', 'D', '3', '0', '0', 'D', '0', '6', '0', '9', '2',
    'A', '8', '6', '4', '8', '8', '6', 'F', '7', '0', 'D', '0', '1', '0', '1',
    '0', '1', '0', '5', '0', '0', '0', '3', '8', '1', '8', 'B', '0', '0', '3',
    '0', '8', '1', '8', '7', '0', '2', '8', '1', '8', '1', '0', '0', 'C', '4',
    '9', 'C', 'A', 'C', '3', '4', 'E', 'D', '1', '3', 'A', '5', '2', '0', '6',
    '5', '8', 'F', '6', 'F', '8', 'E', '0', '1', '3', '8', 'C', '4', '3', '1',
    '5', 'B', '4', '3', '1', '5', '2', '7', '7', 'E', 'D', '3', 'F', '7', 'D',
    'A', 'E', '5', '3', '0', '9', '9', 'D', 'B', '0', '8', 'E', 'E', '5', '8',
    '9', 'F', '8', '0', '4', 'D', '4', 'B', '9', '8', '1', '3', '2', '6', 'A',
    '5', '2', 'C', 'C', 'E', '4', '3', '8', '2', 'E', '9', 'F', '2', 'B', '4',
    'D', '0', '8', '5', 'E', 'B', '9', '5', '0', 'C', '7', 'A', 'B', '1', '2',
    'E', 'D', 'E', '2', 'D', '4', '1', '2', '9', '7', '8', '2', '0', 'E', '6',
    '3', '7', '7', 'A', '5', 'F', 'E', 'B', '5', '6', '8', '9', 'D', '4', 'E',
    '6', '0', '3', '2', 'F', '6', '0', 'C', '4', '3', '0', '7', '4', 'A', '0',
    '4', 'C', '2', '6', 'A', 'B', '7', '2', 'F', '5', '4', 'B', '5', '1', 'B',
    'B', '4', '6', '0', '5', '7', '8', '7', '8', '5', 'B', '1', '9', '9', '0',
    '1', '4', '3', '1', '4', 'A', '6', '5', 'F', '0', '9', '0', 'B', '6', '1',
    'F', 'C', '2', '0', '1', '6', '9', '4', '5', '3', 'B', '5', '8', 'F', 'C',
    '8', 'B', 'A', '4', '3', 'E', '6', '7', '7', '6', 'E', 'B', '7', 'E', 'C',
    'D', '3', '1', '7', '8', 'B', '5', '6', 'A', 'B', '0', 'F', 'A', '0', '6',
    'D', 'D', '6', '4', '9', '6', '7', 'C', 'B', '1', '4', '9', 'E', '5', '0',
    '2', '0', '1', '1', '1', '\0'};

static const char * MCC_graphmatching_matlabpath_data[] = 
  { "graphmatchin/", "$TOOLBOXDEPLOYDIR/",
    "bitbacket/phd_codesourse/graph_matching_SMAC/",
    "bitbacket/phd_codesourse/graph_matching_SMAC/util/",
    "toolbox/mytools/pmtk3-2april2011/pmtksupportcopy/gaimc1.0-graphalgo/",
    "toolbox/mytools/pmtk3-2april2011/pmtksupportcopy/gaimc1.0-graphalgo/demo/",
    "toolbox/mytools/pmtk3-2april2011/toolbox/algorithms/optimization/",
    "$TOOLBOXMATLABDIR/audiovideo/", "$TOOLBOXMATLABDIR/codetools/",
    "$TOOLBOXMATLABDIR/datafun/", "$TOOLBOXMATLABDIR/datamanager/",
    "$TOOLBOXMATLABDIR/datatypes/", "$TOOLBOXMATLABDIR/demos/",
    "$TOOLBOXMATLABDIR/elfun/", "$TOOLBOXMATLABDIR/elmat/",
    "$TOOLBOXMATLABDIR/funfun/", "$TOOLBOXMATLABDIR/general/",
    "$TOOLBOXMATLABDIR/graph2d/", "$TOOLBOXMATLABDIR/graph3d/",
    "$TOOLBOXMATLABDIR/graphics/", "$TOOLBOXMATLABDIR/guide/",
    "$TOOLBOXMATLABDIR/hds/", "$TOOLBOXMATLABDIR/helptools/",
    "$TOOLBOXMATLABDIR/imagesci/", "$TOOLBOXMATLABDIR/iofun/",
    "$TOOLBOXMATLABDIR/lang/", "$TOOLBOXMATLABDIR/matfun/",
    "$TOOLBOXMATLABDIR/ops/", "$TOOLBOXMATLABDIR/plottools/",
    "$TOOLBOXMATLABDIR/polyfun/", "$TOOLBOXMATLABDIR/randfun/",
    "$TOOLBOXMATLABDIR/scribe/", "$TOOLBOXMATLABDIR/sparfun/",
    "$TOOLBOXMATLABDIR/specfun/", "$TOOLBOXMATLABDIR/specgraph/",
    "$TOOLBOXMATLABDIR/strfun/", "$TOOLBOXMATLABDIR/timefun/",
    "$TOOLBOXMATLABDIR/timeseries/", "$TOOLBOXMATLABDIR/uitools/",
    "$TOOLBOXMATLABDIR/verctrl/", "$TOOLBOXMATLABDIR/winfun/", "toolbox/local/",
    "toolbox/compiler/", "toolbox/images/colorspaces/",
    "toolbox/images/images/", "toolbox/images/imuitools/",
    "toolbox/images/iptformats/", "toolbox/images/iptutils/",
    "toolbox/shared/dastudio/", "toolbox/shared/imageslib/" };

static const char * MCC_graphmatching_classpath_data[] = 
  { "java/jar/toolbox/images.jar" };

static const char * MCC_graphmatching_libpath_data[] = 
  { "" };

static const char * MCC_graphmatching_app_opts_data[] = 
  { "" };

static const char * MCC_graphmatching_run_opts_data[] = 
  { "" };

static const char * MCC_graphmatching_warning_state_data[] = 
  { "off:MATLAB:dispatcher:nameConflict" };


mclComponentData __MCC_graphmatching_component_data = { 

  /* Public key data */
  __MCC_graphmatching_public_key,

  /* Component name */
  "graphmatching",

  /* Component Root */
  "",

  /* Application key data */
  __MCC_graphmatching_session_key,

  /* Component's MATLAB Path */
  MCC_graphmatching_matlabpath_data,

  /* Number of directories in the MATLAB Path */
  50,

  /* Component's Java class path */
  MCC_graphmatching_classpath_data,
  /* Number of directories in the Java class path */
  1,

  /* Component's load library path (for extra shared libraries) */
  MCC_graphmatching_libpath_data,
  /* Number of directories in the load library path */
  0,

  /* MCR instance-specific runtime options */
  MCC_graphmatching_app_opts_data,
  /* Number of MCR instance-specific runtime options */
  0,

  /* MCR global runtime options */
  MCC_graphmatching_run_opts_data,
  /* Number of MCR global runtime options */
  0,
  
  /* Component preferences directory */
  "graphmatchin_965626D3CD7C49064D9BB650C08A42EC",

  /* MCR warning status data */
  MCC_graphmatching_warning_state_data,
  /* Number of MCR warning status modifiers */
  1,

  /* Path to component - evaluated at runtime */
  NULL

};

#ifdef __cplusplus
}
#endif


