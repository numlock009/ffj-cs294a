% all of this stuff should be listed 
% in the previous calling script or you can set them here
% experiment_number = '3' 
% texture = 'skin_228x171'
% image_folder = '/face_segments228x171' 
% script_type = 'hr'
desc = 'rift'
threshold = 0.0005
% extra = ['_', texture, '_', experiment_number, '_', script_type];
extra = ['_new_hair_50x50_2_lr']
% vars_file = ['images', image_folder, '/vars', extra]
project_path
% % classify 
% % we should always call at least training before running this script
% training
% particularly centroids should be defined
centroids_file = ['images/visualization/files/centroids_train', extra, ...
                  '_', desc];
load(centroids_file);
weighted = 1

% paramfile = ['svm_files/svm_param', svm_ext]
testfile = 'svm_files/temp'
predictfile = 'svm_files/temp1'
paramfile = ['images/visualization/files/svm_param', extra, '_', desc]
images_name = ['face_example', int2str(IM) ]
img_file = ['images/visualization/', images_name]
final_image = ['images/visualization/segments/', images_name, svm_ext, ...
               '_', desc]
img_ext = '.jpg'

img_color = imread([img_file, img_ext]);
img = to_gray_double(img_color);

if(size(size(img_color)) < 3)
  img_color = zeros(size(img, 1), size(img, 2), 3);
  img_color(:, :, 1) = img(:, :);
  img_color(:, :, 2) = img(:, :);
  img_color(:, :, 3) = img(:, :);
end

image_width = size(img, 2)
image_height = size(img, 1)
width = 50
height = 50
% for sliding window the step that will be taken.
step = 5

% find keypoints in the image.
points = find_keypoints(img, 'keypt', 'hl', 'threshold', threshold);

features = [];
j = 1;
while( j <= size(points,1) )
  try
    descriptor = get_descriptors(img, 'desc', desc, 'pt', points(j, :));
  catch
    points(j, :) = [];
    continue
  end
  features(j, :) = descriptor(:)';
  j = j + 1;
end

feature = {};
num_rows = ceil(image_height/height);
num_cols = ceil(image_width/width);
num_steps_x = floor(width/step);
num_steps_y = floor(height/step);
for sx = 1:num_steps_x
  for sy = 1:num_steps_y
    feature{sx, sy} = {};
    for i = 1:(num_rows*num_cols)
      feature{sx, sy}{i} = [];
    end
  end
end

% find which keypoints are in which segment for each part of the window
for i = 1:size(points, 1)
  for sx = 1:num_steps_x
    for sy = 1:num_steps_y
      sxx = (sx-1)*step;
      syy = (sy-1)*step;
      row = floor((points(i, 1) - syy) / height);
      col = floor((points(i, 2) - sxx) / width );
      if((row > 0) && (col > 0))
        index = row * num_cols + col + 1;
        feature{sx, sy}{index}(end+1:end+1, :) = features(i, :);
      end
    end
  end
end

% visualize the sliding window data.
fig = figure('Visible', 'off');
hold on;
axis off;
imshow(img_color);

for sx = 1:num_steps_x
  for sy = 1:num_steps_y
    % create the feature vectors
    data = make_feature_vector_(centroids, feature{sx, sy});
    size(data)
    data_good = [];
    good = 0;
    for i=1:size(data, 1)
      if(norm(data(i, :)) ~= 0)
        good = good + 1;
        data_good(good, :) = data(i, :);
      end
    end

    % classify the results
    [meaningless_error, output_good] = test_svm(data_good, ones(size(data_good, 1), 1), ...
                                                paramfile, testfile, predictfile, weighted);


    % remap the output from the patches that where classifiable 
    % to all of the patches
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

    img_output = reshape(output, num_cols, num_rows)';

    for i = 1:num_rows
      for j = 1:num_cols
        if(img_output(i,j) > 0)
          facecolor = 'g';
          c = (j - 1) * width + (sx-1)*step + 1;
          r = (i - 1) * height + (sy-1)*step + 1;
          % img_color(r:(r+height-1), c:(c+width-1), 2) = 128 + img_color(r:(r+height-1), c:(c+width-1), 2)/2;
          patch([c, c + width, c + width, c], [r, r, r+height, r+height],...
                facecolor, 'FaceAlpha', 0.2, 'EdgeColor', facecolor);
        end
      end
    end
  end
end

% imwrite(imresize(img_color, [600, 800]), [final_image, '_', ...
%                     int2str(width), 'x', int2str(height), svm_ext, '_sliding_segments.png']);

saveas(fig, [final_image, '_', int2str(width), 'x', int2str(height), svm_ext, ...
             '_sliding_segments.png']);
close(fig);
