function [descriptors] = descriptors_wrapper(img, keypts)
% choose which descriptor function to use
descriptor_fn = @sift_descriptor;
% descriptor_fn = @rift_descriptor;
% descriptor_fn = @spin_image_descriptor;

% descriptors is num_keypts x num_features cell array
%    num_features is the number of features returned by a descriptor
%    function i.e. 128 for standard sift features and so on
descriptors = {};
% keypts is either n x 3 or n x 2,
%   nx3 if keypts were found at a particular scale which is known
%   nx2 if keypts were found but at no particular scale
for i = 1:size(keypts, 1)
  descriptors{i} = descriptor_fn(img, keypts(i, :));
end
