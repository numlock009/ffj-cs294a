function [hsv_descriptor] = hsv_color_descriptor(img_color, varargin);
hsv_descriptor = rgb2hsv(rgb_color_descriptor(img_color, varargin{:}));
% hsv_descriptor = hsv_descriptor(:, :, 1:2); % V values are too unstable