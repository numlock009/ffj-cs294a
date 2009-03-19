function [rgb_descriptor] = rgb_color_descriptor(img_color, varargin);
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('img_color', @(x)true); % size(x,3) > 2); % @ischar); % @(x)sum(size(x))>0);
p.addParamValue('width', 10, @(x)x>0);
p.addParamValue('height', 10, @(x)x>0);
% by default is the whole image to map color
p.addParamValue('full', true, @(x)true);
p.addOptional('pt', @(x) sum(size(x))>0);
p.parse(img_color, varargin{:});
keypt = p.Results.pt;
full = p.Results.full;

if( size(img_color, 3) < 3 )
  img_temp = repmat(img_color, 1, 3);
  img_color = reshape(img_temp, size(img_color, 1), size(img_color, 2), 3);
end

if(full)
  rgb_descriptor = img_color;
else
  width = p.Results.width;
  height = p.Results.height;
  row = floor(keypt(1)/height)*height + 1;
  col = floor(keypt(2)/width)*width + 1;
  row_end = min(row + height - 1, size(img_color, 1));
  col_end = min(col + width - 1, size(img_color, 2));
  rgb_descriptor = img_color(row:row_end, col:col_end, :);
end
rgb_descriptor = im2double(rgb_descriptor);