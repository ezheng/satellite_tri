function [lon_nor, lat_nor, alt_nor] = normalizeSpaceCoordinates(rpc, lon,lat,alt)

lon_nor = (lon - rpc.longOffset) / rpc.longScale;
lat_nor = (lat - rpc.latOffset) /  rpc.latScale;
alt_nor = (alt - rpc.heightOffset) /rpc.heightScale;


