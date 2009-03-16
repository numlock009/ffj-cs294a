function [feature_size] = whole_features_size(feature_type, width, height, varargin)
switch lower(feature_type)
 case 'rgb'
  feature_size = width*height*3;
 case 'hsv'
  feature_size = width*height*2;
 case 'keypt'
  feature_size = 0;
 otherwise
  disp('Unknown feature type')
end
