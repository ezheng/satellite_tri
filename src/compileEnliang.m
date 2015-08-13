function compileEnliang

% =============== use this if using higher precision arithmetic
% libFilePath = '-LF:\Enliang\library_64\mpir_mpfr_lib';
% libFile1 = '-lmpfr';
% libFile2 = '-lmpir';
% mex( '-IF:\Enliang\library_64\eigen3', '-IF:\Enliang\library_64\mpir_mpfr_lib', libFilePath, libFile1, libFile2, 'triangulate3DPts.cpp');
% =============== 

mex('-I../eigen3', 'triangulate3DPts.cpp');
movefile('triangulate3DPts.mexw64', '../bin/triangulate3DPts_double.mexw64');

%  -IF:\Enliang\library_64\mpir_mpfr_lib










