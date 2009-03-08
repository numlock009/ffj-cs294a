% training


% all of this stuff should be listed in the training script
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

% load('images/skin/vars_train_skin_50x50_5_lr');

paramfile = ['svm_files/svm_param', extra, '_', desc]
testfile = 'svm_files/temp'
predictfile = 'svm_files/temp1'

% make sure these are set in whatever is called before this script
% width = 50
% height = 50

img_dir = 'images/visualization'
final_directory = 'images/visualization/fp'

files = dir(img_dir);
% centroids = load(vars_file);
% centroids = centroids.centroids;

for im = 1:size(files, 1) 
  if(~files(im).isdir)
    img_file = [img_dir, '/', files(im).name]
    img_color = imread(img_file);
    img = to_gray_double(img_color);
    image_width = size(img, 2)
    image_height = size(img, 1)
    
    % get all the image keypoints
    points = find_keypoints(img, 'keypt', 'hl', 'threshold', threshold);

    size(points)
    
    % get the descriptors for each keypoint
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

    size(points)
    size(features)
    feature = {};
    num_rows = ceil(image_height/height);
    num_cols = ceil(image_width/width);
    for i = 1:(num_rows*num_cols)
      feature{i} = [];
    end
    
    num_rows * num_cols
    % find which keypoints are in which segment
    for i = 1:size(points, 1) 
      row = floor(points(i, 1) / height);
      col = floor(points(i, 2) / width );
      index = row * num_cols + col + 1;
      feature{index}(end+1:end+1, :) = features(i, :);
    end 
    
    % make feature vectors and filter out vectors that are empty
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
    
    % classify the results
    [meaningless_error, output_good] = test_svm(data_good, ones(size(data_good, 1), 1), ...
                                                paramfile, testfile, predictfile);
    
    % remap the output from the patches that where classifiable 
    % to all of the patches
    output = zeros(size(data, 1), 1);
    good = 0;
    for i=1:size(data, 1)
      if(norm(data(i, :)) ~= 0)
        good = good + 1;
        output(i) = output_good(good);
      else
        output(i) = -1; % automatically classify the result as negative
                        % if there were no results
      end
    end
    
    img_output = reshape(output, num_cols, num_rows)';
    
    for i = 1:num_rows
      for j = 1:num_cols
        if(img_output(i,j) > 0)
          facecolor = 'g';
          c = (j - 1) * width + 1;
          r = (i - 1) * height + 1;
          img_crop = imcrop(img_color, [c, r, width-1, height-1]);
          imwrite(img_crop, strcat(final_directory, '/', 'fp_', ...
                                   int2str(c), 'x', int2str(r), extra, '_', ...
                                   files(im).name), ...
                  'Quality', 100);
          
        end
      end
    end
    
    fig = figure('Visible', 'off');
    hold on;
    axis off;
    imshow(img);
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
    saveas(fig, [final_directory, '/', files(im).name, int2str(width), ...
                 'x', int2str(height), extra, '_segments.png']);
    close(fig);
  end
end


