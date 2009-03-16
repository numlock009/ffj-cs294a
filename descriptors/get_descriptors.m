function [descriptor] = get_descriptors(img_file, varargin)
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('img_file', @(x)true); % @ischar); % @(x)sum(size(x))>0);
p.addOptional('desc', @ischar);
% @(x)any(strcmpi(lower(x),{'sift', 'rift', 'spin', ...
%                     'color'})));
p.addOptional('pt', @(x) sum(size(x))>0);
p.parse(img_file, varargin{:});
desc = p.Results.desc;
keypt = p.Results.pt; % in row, col, order

if(ischar(img_file))
  img_color = imread(img_file);
else
  img_color = img_file;
end
img = to_gray_double(img_color);

desc = regexp(desc, '_', 'split');
desc = sort(desc);
descriptor = [];
for i=1:size(desc,2)
  switch lower(desc{i})
   case {'rift'}
    p.addParamValue('cellsize', 10, @(x)x>0);
    p.addParamValue('ori_binsize', 8, @(x)x>0);
    p.addParamValue('dist_binsize', 4, @(x)x>0);
    p.parse(img_file, varargin{:});
    cellsize = p.Results.cellsize;
    ori_binsize = p.Results.ori_binsize;
    dist_binsize = p.Results.dist_binsize;

    % use RIFT descriptors
    descriptor_val = RIFT_descriptor(img, keypt(1), keypt(2), cellsize, ori_binsize, ...
                                     dist_binsize);
   case {'spin'}
    % use the harris_laplace algorithm
    p.addParamValue('cellsize', 10, @(x)x>0);
    p.addParamValue('intens_binsize', 10, @(x)x>0);
    p.addParamValue('dist_binsize', 10, @(x)x>0);
    p.parse(img_file, varargin{:});
    cellsize = p.Results.cellsize;
    intens_binsize = p.Results.intens_binsize;
    dist_binsize = p.Results.dist_binsize;
    
    descriptor_val = spin_descriptor(img, keypt(1), keypt(2), cellsize , intens_binsize, ...
                                     dist_binsize);
   case 'sift'
    descriptor_val = sift_descriptor(img, keypt);
   otherwise
    disp('Unknown descriptor selector')
    descriptor_val = [];
  end
  descriptor = [descriptor; descriptor_val(:)];
end
