% if the keypoint directory or file is a directory calculate the
% keypoints, otherwise load it from the file
function [points] = getKeypoints(directory_or_files, varargin)
points = {};
for i = 1:size(directory_or_files, 2)
  ft = exist(directory_or_files{i});
  if(ft == 7)
    points{i} = findAllKeypoints(directory_or_files{i}, varargin{:});
    write_points_to_file(directory_or_files{i}, points{i}, varargin{:});
  elseif(ft == 2)
    points{i} = read_points_from_file(directory_or_files{i});
  end
end
