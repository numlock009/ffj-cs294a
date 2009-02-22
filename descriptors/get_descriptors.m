function [points] = get_descriptors(img, varargin)
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('img', @(x)sum(size(x))>0);
p.addOptional('desc', @(x)any(strcmpi(lower(x),{'sift', 'rift', 'spin'})));
p.addOptional('pt', @(x) sum(size(x))>0);
p.parse(img, varargin{:});
desc = p.Results.desc;
keypt = p.Results.pt;

switch lower(desc)
 case {'rift'}
  p.addParamValue('cellsize', 10, @(x)x>0);
  p.addParamValue('ori_binsize', 8, @(x)x>0);
  p.addParamValue('dist_binsize', 4, @(x)x>0);
  p.parse(img, varargin{:});
  cellsize = p.Results.cellsize;
  ori_binsize = p.Results.ori_binsize;
  dist_binsize = p.Results.dist_binsize;

  % use RIFT descriptors
  points = RIFT_descriptor(img, keypt(1), keypt(2), cellsize, ori_binsize, ...
                           dist_binsize);
 case {'spin'}
  % use the harris_laplace algorithm
  p.addParamValue('cellsize', 10, @(x)x>0);
  p.addParamValue('intens_binsize', 10, @(x)x>0);
  p.addParamValue('dist_binsize', 10, @(x)x>0);
  p.parse(img, varargin{:});
  cellsize = p.Results.cellsize;
  intens_binsize = p.Results.intens_binsize;
  dist_binsize = p.Results.dist_binsize;
  
  points = spin_descriptor(img, keypt(1), keypt(2), cellsize , intens_binsize, ...
                           dist_binsize);
 case 'sift'
  points = sift_descriptor(img, keypt);
 otherwise
  disp('Unknown keypoint selector')
end
