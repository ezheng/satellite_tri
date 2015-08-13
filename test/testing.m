function [projectionErr, triangulated3DPtsError] = testing(noiseLevel)
% noiseLevel = 1;

rng('default');

% coeffs = load('coeffs_xiapu.mat');
% coeffs = load('coeffs_tw1.mat');
% coeffs = load('coeffs_052333524010_01_P001_PAN.mat');
coeffs = load('coeffs_xiapu.mat');
rpc1 = coeffs.rpc1;
rpc2 = coeffs.rpc2;
a = load('coord_xiapu.mat');
% a = load('coord_xiapu.mat');
% a = load('coord_tw1.mat');
% a = load('coord_052333524010_01_P001_PAN.mat');

if(nargin == 0)
    noiseLevel = 0;
end
long_lat_height_param = [rpc1.longOffset, rpc1.latOffset, rpc1.heightOffset, rpc2.longOffset, rpc2.latOffset, rpc2.heightOffset, ...
         rpc1.longScale, rpc1.latScale, rpc1.heightScale, 1/rpc2.longScale, 1/rpc2.latScale, 1/rpc2.heightScale];   
INVERSE_LINE_NUM1 = rpc1.INVERSE_LINE_NUM;
INVERSE_LINE_DEN1 = rpc1.INVERSE_LINE_DEN;
INVERSE_SAMP_NUM1 = rpc1.INVERSE_SAMP_NUM;
INVERSE_SAMP_DEN1 = rpc1.INVERSE_SAMP_DEN;
INVERSE_LINE_NUM2 = rpc2.INVERSE_LINE_NUM;
INVERSE_LINE_DEN2 = rpc2.INVERSE_LINE_DEN;
INVERSE_SAMP_NUM2 = rpc2.INVERSE_SAMP_NUM;
INVERSE_SAMP_DEN2 = rpc2.INVERSE_SAMP_DEN;


numOfTests = 10000;
% methods = {'double','64'};
methods = {'double'};
% methods = {''};
% methods = {'double_time'};
% methods = {''};
numOfMethods = numel(methods);
projectionErr = zeros(numOfTests, numOfMethods);

triangulated3DPts = zeros(3, numOfTests);

for kk = 1:numOfTests
% for kk = 6082
    kk
    
    lon_val = a.lon(kk);
    lat_val = a.lat(kk);
    alt_val = a.alt(kk);
    [lon1_val, lat1_val, alt1_val] = normalizeSpaceCoordinates(rpc1, lon_val,lat_val,alt_val);

    [row1, col1] = addNoise(noiseLevel, a.row1(kk), a.col1(kk), rpc1);
    [row2, col2] = addNoise(noiseLevel, a.row2(kk), a.col2(kk), rpc2);

    for j = 1:numOfMethods
 
        A = feval( ['triangulate3DPts_', methods{j}] , INVERSE_LINE_NUM1, INVERSE_LINE_DEN1, INVERSE_SAMP_NUM1, INVERSE_SAMP_DEN1, INVERSE_LINE_NUM2, INVERSE_LINE_DEN2, INVERSE_SAMP_NUM2, INVERSE_SAMP_DEN2, ...
             long_lat_height_param, [row1, col1, row2, col2]);   
        numOfSolutionsAll = sum( all(A == 0) == 0);
        %     toc
        [err1, I] = min(  sum( ( A(2:3,1:numOfSolutionsAll) - repmat([lat_val; lon_val],1,numOfSolutionsAll )).^2 , 1)  );
        [computedLon2, computedLat2, computedAlt2] = normalizeSpaceCoordinates(rpc2, A(3,I), A(2,I), A(1,I) );
        
        if(noiseLevel ~= 0)
            triangulated3DPts(:,kk ) = LM_3Dpoints(A(:,I), row1,col1,row2,col2, rpc1, rpc2);    % do bundle adjustment
        else
            triangulated3DPts(:,kk ) = A(:,I);  
        end
        triangulated3DPtsError(kk) = compareDifference(triangulated3DPts(:,kk), [alt_val; lat_val; lon_val] );  % the error unit is meter
        
        projCol2 = eval_rpc(INVERSE_SAMP_NUM2, computedLat2, computedLon2, computedAlt2) / eval_rpc(INVERSE_SAMP_DEN2, computedLat2, computedLon2, computedAlt2);

        [~, M1] = deNormalizeImageCoordinates(row2, projCol2, rpc2);
        [~, M2] = deNormalizeImageCoordinates(row2, col2, rpc2);
        % col_diff(kk)  = abs( M1 - M2 );
        projectionErr(kk,j) = abs(M1 - M2);
    end
end

% for i = 1:numOfMethods
%     drawErrorHistogram( projectionErr(:,i) , 'pixel', '.', methods{i});
% end

end

function error = compareDifference(estimated3DPts, groundTruth)

    estimated3DPts = fliplr(estimated3DPts'); % alt, lat, lon => lon, lat, alt, in the world coordinate (object space)
    [x1,y1,~] = deg2utm(estimated3DPts(:,2) , estimated3DPts(:,1) );
    
    groundTruth = fliplr(groundTruth'); % alt, lat, lon => lon, lat, alt, in the world coordinate (object space)
    [x_ground,y_ground,~] = deg2utm(groundTruth(:,2) , groundTruth(:,1) );
    
    error = norm( [x1,y1,estimated3DPts(3)] - [x_ground,y_ground,groundTruth(3)] );
    
end

function [newRow, newCol] = addNoise(noiseLevel, normalizedRow, normalizedCol , rpc)    
%   Add zero mean Gaussian noise. Both the input and the output are the normalized coordinates.
    if (noiseLevel == 0)
       newRow = normalizedRow;
       newCol = normalizedCol;
       return;
    end
    randomDist = randn * noiseLevel;
    angle = (rand() * 360 * pi/180);
    randomNoise = [cos(angle); sin(angle)] * randomDist;
   
    newRow = normalizedRow +  randomNoise(1)/rpc.lineScale;  % normalized coordinates
    newCol = normalizedCol +  randomNoise(2)/rpc.sampScale;
    
end

