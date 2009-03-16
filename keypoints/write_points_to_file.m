function write_points_to_file(points_dir, points, varargin)
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('points_dir', @ischar);
p.addRequired('points', @iscell);
p.addParamValue('ext', '', @ischar);
p.parse(points_dir, points, varargin{:});

points_dir
last_dir = regexp(points_dir, '(?<=/)\w+$', 'match')
points_file = [points_dir, '/', '..', '/', last_dir{1}, '_points', '_', p.Results.ext];
split_features = {};
fid = fopen(points_file, 'w');
fid
for image_num = 1:size(points, 2);  
  fname = points{image_num}{1};
  keypoints = points{image_num}{2};
  fprintf(fid, '%s\n', fname);
  fprintf(fid, '%d\t', size(keypoints,1));
  fprintf(fid, '%d\n', size(keypoints,2));
  write_points(fid, keypoints);
end
fclose(fid);
