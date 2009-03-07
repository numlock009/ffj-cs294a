% all of this stuff should be listed in the classify script
% experiment_number = '3' 
% texture = 'skin_228x171'
% image_folder = '/face_segments228x171' 
% script_type = 'hr'
% desc = 'rift'
% threshold = 0.005
% extra = ['_', texture, '_', experiment_number, '_', script_type];
% vars_file = ['images', image_folder, '/vars', extra]
project_path
% % classify 
% % we should always call at least training before running this script
% training

paramfile = ['svm_files/svm_param', extra, '_', desc]
testfile = 'svm_files/temp'
predictfile = 'svm_files/temp1'
img_file = 'images/test/DSCN0702_'
img_ext = '.jpg'

img = prepare_image([img_file, img_ext]);
image_width = size(img, 2)
image_height = size(img, 1)
width = 640
height = 480

points = find_keypoints(img, 'keypt', 'hl', 'threshold', threshold);

features = [];
for j = 1:size(points,1)
  try
    descriptor = get_descriptors(img, 'desc', desc, 'pt', points(j, :));
  catch
    points(j, :) = [];
    continue
  end
  features(j, :) = descriptor(:)';
end

% centroids = load(vars_file);
% centroids = centroids.centroids;

feature = {};
num_rows = floor(image_height/height);
num_cols = floor(image_width/width);
for i = 1:(num_rows*num_cols)
  feature{i} = [];
end

% find which keypoints are in which segment
for i = 1:num_points
  row = floor(points(i, 1) / height);
  col = floor(points(i, 2) / width );
  index = row * num_cols + col + 1;
  feature{index}(end+1:end+1, :) = features(i, :);
end 

data = make_feature_vector_(centroids, feature);
size(data)
data_good = [];
good = 0;
for i=1:size(data, 1)
  if(norm(data(i, :)) ~= 0)
    good = good + 1;
    data_good(good, :) = data(i, :);
  end
end

[meaningless_error, output_good] = test_svm(data_good, ones(size(data_good, 1), 1), ...
                                            paramfile, testfile, predictfile);

output = zeros(size(data, 1), 1);
good = 0;
for i=1:size(data, 1)
  if(norm(data(i, :)) ~= 0)
    good = good + 1;
    output(i) = output_good(good);
  else
    output(i) = -1;
  end
end

fig = figure('Visible', 'off');
hold on;
axis off;
imshow(img);
img_output = reshape(output, num_cols, num_rows)';
for i = 1:num_rows
  for j = 1:num_cols
    if(img_output(i,j) > 0)
      facecolor = 'g';
      c = (j - 1) * width + 1;
      r = (i - 1) * height + 1;
      patch([c, c + width, c + width, c], [r, r, r+height, r+height],...
            facecolor, 'FaceAlpha', 0.2, 'EdgeColor', facecolor);
    else
      facecolor = 'r';
    end
  end
end

saveas(fig, [img_file, int2str(width), 'x', int2str(height), '_segments.png']);
close(fig);