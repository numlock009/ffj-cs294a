function [all_features, split_features] = generate_features(points_files, varargin)
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('points_files', @iscell);
p.addOptional('desc', @(x)any(strcmpi(lower(x),{'sift', 'rift', 'spin'})));
p.addParamValue('max_points', 100, @(x) x>0);
p.parse(points_files, varargin{:});
max_points = p.Results.max_points;

all_features = [];
split_features = {};
index = 1;
for fs = 1:size(points_files, 2)
  fid = fopen( points_files{fs} , 'r');
  split_features{fs} = {};
  image_num = 1;
  while(true)
    fname = fscanf(fid, '%s', 1);
    if(isempty(fname)), break, end;
    m = fscanf( fid , '%d' , [1 2]);
    keypoints = fscanf(fid , '%d' , m);
    keypoints = reshape(keypoints, [m(2) m(1)])';

    j = 1;
    n = min(max_points, size(keypoints, 1));
    k = 1;
    split_features{fs}{image_num} = [];
    while( j <= size(keypoints, 1) && k <= n)
      try
        descriptor = get_descriptors(prepare_image( fname ), varargin{:}, ...
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
    image_num = image_num + 1;
  end
  fclose(fid);
end
