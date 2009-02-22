function [features] = get_features(points_file, varargin)
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('points_file', @ischar);
p.addOptional('desc', @(x)any(strcmpi(lower(x),{'sift', 'rift', 'spin'})));
p.addParamValue('max_points', 100, @(x) x>0);
p.parse(points_file, varargin{:});
max_points = p.Results.max_points;

features = {};
fid = fopen( points_file , 'r');
index = 0;
while(true)
  fname = fscanf(fid, '%s', 1);
  if(isempty(fname)), break, end;
  m = fscanf( fid , '%d' , [1 2]);
  keypoints = fscanf(fid , '%d' , m);
  keypoints = reshape(keypoints, [m(2) m(1)])';
  index = index + 1;% represents a single image;
  for j = 1 : min(max_points, size(keypoints, 1))
    descriptor = get_descriptors(prepare_image( fname ), varargin{:}, ...
                                               'pt', keypoints(j,:));
    features{index} = descriptor(:)'; % same as reshaping into a 1xsize1*size2 vector
                                      % point's descriptor
  end
end
fclose(fid);
