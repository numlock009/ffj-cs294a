function [maxes] = local_max_matrix(type, val, radius)
switch lower(type)
 case 'window'
  maxes = ordfilt2(val, radius^2, ones(radius)); % find in a squre window
  maxes = maxes == val;
 case 'disk'
  mask = fspecial('disk', radius) > 0;
  maxes = ordfilt2(val, sum(mask(:)), mask); % find in a disk window
  maxes = maxes == val;
 case 'regular' 
  % find a local maximum > 0 comparing to the 8 neighboring
  % pixels
  maxes = imextendedmax(val, 0); 
 otherwise
  error('Unknown max finding type');
end
