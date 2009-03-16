function [all_features, split_features] = generate_features(points, varargin)
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('points', @iscell);
p.addOptional('desc', @(x)any(strcmpi(lower(x),{'sift', 'rift', 'spin'})));
p.addParamValue('max_points', 100, @(x) x>0);
p.parse(points, varargin{:});
max_points = p.Results.max_points;

all_features = [];
split_features = {};
index = 1;
for fs = 1:size(points, 2)
  split_features{fs} = {};
  for image_num = 1:size(points{fs}, 2)
    fname = points{fs}{image_num}{1};
    keypoints = points{fs}{image_num}{2};
    split_features{fs}{image_num} = [];
    j = 1;
    k = 1;
    n = min(max_points, size(keypoints, 1));
    while( j <= size(keypoints, 1) && k <= n)
      try
        descriptor = get_descriptors(fname, varargin{:}, ...
                                            'pt', keypoints(j,:));
      catch
        j = j + 1;
        continue;
      end
      all_features(index, :) = descriptor(:)'; % same as reshaping into a 1xsize1*size2 vector
      split_features{fs}{image_num}(k, :) = all_features(index, :);                                               
      index = index+1;                     % represents a
      j = j + 1;                           % point's descriptor
      k = k + 1;
    end
  end
end
