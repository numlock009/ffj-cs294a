function [feature_val] = rgb_histogram(img, varargin)
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('img', @(x)(sum(size(x))>=5));
p.addParamValue('color_binsize', 10, @(x)x>0);
p.parse(img, varargin{:});
binsize = p.Results.color_binsize;
colors = rgb_color_descriptor(img, varargin{:});
num_values = size(img, 1)*size(img, 2);
feature_val = hist3d(colors, binsize)/num_values;