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
function [ keypoints ] = findAllKeypoints(directories, varargin)
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('directories', @iscell);
p.addParamValue('keypt', 'hl', @(x)any(strcmpi(x,{'h', 'harris', ...
                    'harris_laplace','hl','sift'})));
p.parse(directories, varargin{:});

keypoints = {}; % file -> [] of keypoints 
pts = 0;
for d = 1:size(directories, 2)
  direc = directories{d};
  files = dir(direc);
  j = 1;
  keypoints{d} = {};
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
      keypoints{d}{j} = {};
      keypoints{d}{j}{1} = fname;
      keypoints{d}{j}{2} = points;
      j = j + 1;
      pts = pts+1;
    end
  end
end
