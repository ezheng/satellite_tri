function  [row,col] = deNormalizeImageCoordinates(normalizedRow, normalizedCol, rpc)

row = normalizedRow * rpc.lineScale  + rpc.lineScale;
col = normalizedCol * rpc.sampScale + rpc.sampScale;

end