function K = construct_calibration_matrix( calibfile )
% zgradi kalibracijsko matriko K iz ocen gori��ne razdalje v slikovnih
% elementih (skaliranih glede na dimenzije senzorja), stri�nega popa�enja
% in projekcijskega centra

dat = load(calibfile) ;
K = [ dat.fc(1) dat.alpha_c dat.cc(1);...
      0        dat.fc(2)  dat.cc(2);...
      0        0         1         ] ;