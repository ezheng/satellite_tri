function testAgainstNoise()

addpath '../bin';

numOfCores = 8;
noiseLevel = [0: 0.5 : 5];

% -------------------------------------------------------------------
setMultiThreadContext(true, numOfCores);
for i = 1:numel(noiseLevel)
   [projError(:,i), points3DError(:,i)] = testing(noiseLevel(i));
end







