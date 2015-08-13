function x= LM_3Dpoints(X3D, row1,col1,row2,col2, rpc1, rpc2)

% X3D - lattitude, longtitude, altitude

matches_2D_Inliers = [row1, col1, row2, col2];
param_val = X3D;
% F = parameterfun(param_val, matches_2D_Inliers,rpc1, rpc2);


f = @(param)parameterfun(param, matches_2D_Inliers,rpc1,rpc2);
options = optimoptions(@lsqnonlin, 'Display', 'off', 'Algorithm', 'levenberg-marquardt', 'TolX', 1e-12, 'TolFun', 1e-12);
tic
x = lsqnonlin(f, param_val, [], [], options);
toc
end


function F = parameterfun(param, matches_2D_Inliers,rpc1, rpc2)
%        normalizeSpaceCoordinates(rpc, lon,lat,alt)
    [lon_nor1, lat_nor1, alt_nor1] = normalizeSpaceCoordinates(rpc1, param(3), param(2), param(1) );
    [lon_nor2, lat_nor2, alt_nor2] = normalizeSpaceCoordinates(rpc2, param(3), param(2), param(1) );
    
%     projections = zeros(1,4)
    
    projRow1 = eval_rpc(rpc1.INVERSE_LINE_NUM, lat_nor1, lon_nor1, alt_nor1) / eval_rpc(rpc1.INVERSE_LINE_DEN, lat_nor1, lon_nor1, alt_nor1);
    projCol1 = eval_rpc(rpc1.INVERSE_SAMP_NUM, lat_nor1, lon_nor1, alt_nor1) / eval_rpc(rpc1.INVERSE_SAMP_DEN, lat_nor1, lon_nor1, alt_nor1);

    projRow2 = eval_rpc(rpc2.INVERSE_LINE_NUM, lat_nor2, lon_nor2, alt_nor2) / eval_rpc(rpc2.INVERSE_LINE_DEN, lat_nor2, lon_nor2, alt_nor2);
    projCol2 = eval_rpc(rpc2.INVERSE_SAMP_NUM, lat_nor2, lon_nor2, alt_nor2) / eval_rpc(rpc2.INVERSE_SAMP_DEN, lat_nor2, lon_nor2, alt_nor2);

    F = matches_2D_Inliers - [projRow1, projCol1, projRow2, projCol2] ;
    
end

function res = eval_rpc(C, lat, lon, alt)
    res = C(1) + C(2) .* lon + C(3) .* lat + C(4) .* alt + C(5) .* lon .* lat + C(6) .* lon .* alt + C(7) .* lat .* alt + C(8) .* lon .* lon + C(9) .* lat .* lat + C(10) .* alt .* alt + C(11) .* lat .* lon .* alt + C(12) .* lon .* lon .* lon + C(13) .* lon .* lat .* lat + C(14) .* lon .* alt .* alt + C(15) .* lon .* lon .* lat + C(16) .* lat .* lat .* lat + C(17) .* lat .* alt .* alt + C(18) .* lon .* lon .* alt + C(19) .* lat .* lat .* alt + C(20) .* alt .* alt .* alt;
end

