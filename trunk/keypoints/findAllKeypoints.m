% directory is the directory the files are in
% filename is the file which you want to output
% keypt_type represents the kind of keypoints you want to find 
% like 'harris' or 'harris_laplace' 'hl', or 'sift'
% 
% varargin is for parameters
%     keypt = the type of keypoint detector we want to use
%     k
%     threshold
%     sigma
%     width
function [ min1  min2 points_files ] = findAllKeypoints(directories, varargin)
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('directories', @iscell);
p.addOptional('keypt', 'hl', @(x)any(strcmpi(x,{'h', 'harris', ...
                    'harris_laplace','hl','sift'})));
p.addOptional('ext', '', @ischar);
p.parse(directories, varargin{:});

min1 = [];
min2 = [];
points_files = {};
pts = 0;
for d = 1:size(directories, 2)
  direc = directories{d};
  files = dir(direc);
  last_dir = regexp(direc, '(?<=/)\w+$', 'match');
  points_file = [direc,'/', '..', '/', last_dir{1}, '_points', p.Results.ext];
  points_files{d} = points_file;
  fid = fopen(points_file, 'w');
  for i = 1:size(files, 1)
    if(~files(i).isdir)
      % because each file gives an image file name dependent on the path
      % you'll have to manually edit the points file to be consistent
      % with where your images are located.
      fname = strcat(pwd, '/', directories{d}, '/' , files(i).name);
      try
        img = prepare_image(fname);
        points = find_keypoints(img, varargin{:});
      catch ME1
        % Get last segment of the error message identifier.
        idSegLast = regexp(ME1.identifier, '(?<=:)\w+$', 'match'); 
        if( strcmp(idSegLast, 'fileOpen') || ... % couldn't open file
            strcmp(idSegLast, 'fileFormat')) % couldn't read image =>
                                             % probably not an image
          continue;
        else
          fname
          disp(ME1.identifier);
          rethrow(ME1); % otherwise probably something to do with the
                        % options or something
        end
      end
      
      pts = pts+1;
      min1(pts) = min( size(points, 1));
      min2(pts) = min( size(points, 2));
      fprintf(fid, '%s\n', fname);
      fprintf(fid, '%d\t', size(points,1));
      fprintf(fid, '%d\n', size(points,2));
      write_points(fid , points);
    end
  end
  fclose(fid);
end
min1 = min(min1(:));
min2 = min(min2(:));