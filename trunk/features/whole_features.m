function [data_val] = whole_features(feature_type, img, varargin)
data_val = [];
switch lower(feature_type)
 case 'rgb'
  data_val = rgb_color_descriptor(img, varargin{:});
 case 'hsv'
  data_val = hsv_color_descriptor(img, varargin{:});
 case 'keypt'
  % do nothing
 otherwise
  disp('Unknown feature type')
end
