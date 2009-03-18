function h = hist3d(values, binsize)
% values is a 3d array with values between 0 and 1.
bins = floor(1 + values*binsize);
bins = reshape(bins, size(bins, 1) * size(bins, 2), size(bins,3));
h = zeros(binsize, binsize, binsize);
for i = 1:size(bins,1)
  h(bins(i,1), bins(i,2), bins(i, 3)) = h(bins(i,1), bins(i,2), bins(i, 3)) + 1;
end
