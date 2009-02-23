function [points] = find_keypoints(img, varargin)
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('img', @(x)sum(size(x))>0);
p.addOptional('keypt', @(x)any(strcmpi(lower(x),{'h', 'harris', ...
                    'harris_laplace','hl','sift'})));
p.parse(img, varargin{:});

keypt = p.Results.keypt;

switch lower(keypt)
 case {'harris', 'h'}
  % use the plain harris_corner algorithm
  p.addParamValue('threshold', 0.005, @(x)x>0);
  p.addParamValue('k', 0.04, @(x)x>0);
  p.addParamValue('sigma', 1.5, @(x)x>0);
  p.addParamValue('width', 5, @(x) x >= 1 && mod(x, 2) == 1);
  p.addParamValue('dx', [-1 0 1], @isvector);
  p.parse(img, varargin{:});
  
  threshold = p.Results.threshold;
  k = p.Results.k;
  sigma = p.Results.sigma;
  dx = p.Results.dx;
  width = min(max(1, p.Results.width), floor(6 * sigma + 1));

  points = harris_corner(img, threshold, k, width, sigma, dx);
 case {'harris_laplace', 'hl'}
  % use the harris_laplace algorithm
  p.addParamValue('threshold', 0.005, @(x)x>0);
  p.addParamValue('k', 0.04, @(x)x>0);
  p.addParamValue('sigma', 1.5, @(x)x>0);
  p.parse(img, varargin{:});
  
  threshold = p.Results.threshold;
  k = p.Results.k;
  sigma = p.Results.sigma;
  
  hlt0 = clock
  points = harris_laplace(img, threshold, k, sigma);
  hlt1 = etime(clock,hlt0)*1000
 case 'sift'
  points = sift_keypts(img);
 otherwise
  disp('Unknown keypoint selector')
end
