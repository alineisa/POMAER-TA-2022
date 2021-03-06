@echo off
set MATLAB=C:\PROGRA~1\MATLAB\R2016b
set MATLAB_ARCH=win64
set MATLAB_BIN="C:\Program Files\MATLAB\R2016b\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=.\
set LIB_NAME=VORTEX_INDUCED_mex
set MEX_NAME=VORTEX_INDUCED_mex
set MEX_EXT=.mexw64
call "C:\PROGRA~1\MATLAB\R2016b\sys\lcc64\lcc64\mex\lcc64opts.bat"
echo # Make settings for VORTEX_INDUCED > VORTEX_INDUCED_mex.mki
echo COMPILER=%COMPILER%>> VORTEX_INDUCED_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> VORTEX_INDUCED_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> VORTEX_INDUCED_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> VORTEX_INDUCED_mex.mki
echo LINKER=%LINKER%>> VORTEX_INDUCED_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> VORTEX_INDUCED_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> VORTEX_INDUCED_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> VORTEX_INDUCED_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> VORTEX_INDUCED_mex.mki
echo BORLAND=%BORLAND%>> VORTEX_INDUCED_mex.mki
echo OMPFLAGS= >> VORTEX_INDUCED_mex.mki
echo OMPLINKFLAGS= >> VORTEX_INDUCED_mex.mki
echo EMC_COMPILER=lcc64>> VORTEX_INDUCED_mex.mki
echo EMC_CONFIG=optim>> VORTEX_INDUCED_mex.mki
"C:\Program Files\MATLAB\R2016b\bin\win64\gmake" -B -f VORTEX_INDUCED_mex.mk
