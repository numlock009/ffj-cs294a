function write_points_to_file(points_dirs, points, varargin)
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('points_dirs', @iscell);
p.addRequired('points', @iscell);
p.addParamValue('ext', '', @ischar);
p.parse(points_dirs, points, varargin{:});

for fs = 1:size(points, 2)
  points_dirs{fs}
  last_dir = regexp(points_dirs{fs}, '(?<=/)\w+$', 'match')
  points_file = [points_dirs{fs}, '/', '..', '/', last_dir{1}, '_points', '_', p.Results.ext];
  split_features{fs} = {};
  fid = fopen(points_file, 'w');
  fid
  for image_num = 1:size(points{fs}, 2);  
    fname = points{fs}{image_num}{1};
    keypoints = points{fs}{image_num}{2};
    fprintf(fid, '%s\n', fname);
    fprintf(fid, '%d\t', size(keypoints,1));
    fprintf(fid, '%d\n', size(keypoints,2));
    write_points(fid, keypoints);
  end
  fclose(fid);
end
