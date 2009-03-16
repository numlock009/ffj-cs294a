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
% make sure these are set in whatever is called before this script
% width = 50
% height = 50
% img_dir = 'images/visualization'
% final_directory = 'images/visualization/fp'
project_path
% % classify 
% % we should always call at least training before running this script
% training
%% or we load the necessary vars from a variables file
% load('images/skin/vars_train_skin_50x50_5_lr');

paramfile = ['svm_files/svm_param', svm_ext]
testfile = 'svm_files/temp'
predictfile = 'svm_files/temp1'
feature_types = sort(regexp(feature_type, '_', 'split'));

files = dir(img_dir);

for im = 1:size(files, 1) 
  if(~files(im).isdir)
    img_file = [img_dir, '/', files(im).name]
    try, img_color = imread(img_file);, catch, continue, end
    img = to_gray_double(img_color);

    if(size(size(img_color)) < 3)
      img_color = zeros(size(img, 1), size(img, 2), 3);
      img_color(:, :, 1) = img(:, :);
      img_color(:, :, 2) = img(:, :);
      img_color(:, :, 3) = img(:, :);
    end

    image_width = size(img, 2)
    image_height = size(img, 1)
    
    % get all the image keypoints
    pt_file = [img_file, '_', keypt, '_', num2str(threshold)]
    if(exist(pt_file) == 2)
      fid = fopen(pt_file, 'r');
      points = read_points(fid);
      fclose(fid);
    else
      points = find_keypoints(img, 'keypt', keypt, ...
                              'threshold', threshold);
      fid = fopen(pt_file, 'w');
      fprintf(fid, '%d\t', size(points,1));
      fprintf(fid, '%d\n', size(points,2));
      write_points(fid, points);
      fclose(fid);
    end
    size(points)
    
    % get the descriptors for each keypoint
    features = [];
    j = 1;
    while( j <= size(points,1) )
      try
        descriptor = get_descriptors(img_color, 'desc', desc, 'pt', points(j, :));
      catch ME
        points(j, :) = [];
        continue
      end
      features(j, :) = descriptor(:)';
      j = j + 1;
    end

    % whole patch features
    data = [];
    for y = 1:height:image_height
      for x = 1:width:image_width
        data_pt = [];
        for k = 1:size(feature_types, 2)
          data_val = [];
          try
            data_val = whole_features(feature_types{k}, ...
                                      img_color(y:y+height-1, x:x+width-1, :));
          catch
            % only whole feature we know about are 3 channel color
            % features
            data_val = zeros(1, whole_features_size(feature_types{k}, ...
                                                    width, height));
          end
          data_pt = [data_pt, data_val(:)'];
        end
        data = [data; data_pt];
      end
    end
    size(data)

    size(points)
    size(features)
    size(centroids)
    feature = {};
    num_rows = ceil(image_height/height);
    num_cols = ceil(image_width/width);
    for i = 1:(num_rows*num_cols)
      feature{i} = [];
    end
    
    % find which keypoints are in which segment
    for i = 1:size(points, 1) 
      row = floor(points(i, 1) / height); % points are in row, col order
      col = floor(points(i, 2) / width );
      index = row * num_cols + col + 1;
      feature{index}(end+1:end+1, :) = features(i, :);
    end

    % make feature vectors and filter out vectors that are empty
    data = [make_feature_vector_(centroids, feature), data];
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
          if((c + width - 1 > image_width) || (r + height -1 > image_height)), continue, end
            
          img_crop = imcrop(img_color, [c, r, width-1, height-1]);
          imwrite(img_crop, strcat(final_directory, '/', 'fp_', ...
                                   int2str(c), 'x', int2str(r), svm_ext, '_', ...
                                   files(im).name), ...
                  'Quality', 100);
          
        end
      end
    end
    
    % fig = figure('Visible', 'off');
    % hold on;
    % axis off;
    % imshow(img);
    num_rows
    num_cols
    for i = 1:num_rows
      for j = 1:num_cols
        if(img_output(i,j) > 0)
          facecolor = 'g';
          c = (j - 1) * width + 1;
          r = (i - 1) * height + 1;
	  y = r + height - 1;
          if( y > image_height)
	    y = image_height;
          end
	  x = c + width - 1;
          if(x > image_width)
	    x = image_width;
          end
          img_color(r:y, c:x, 2) = 128 + img_color(r:y, c:x, 2)/2;
%          patch([c, c + width, c + width, c], [r, r, r+height, r+height],...
%                facecolor, 'FaceAlpha', 0.2, 'EdgeColor', facecolor);
        end
      end
    end
    imwrite(imresize(img_color, [600, 800]), [img_dir, '/segments/', files(im).name, int2str(width), ...
                    'x', int2str(height), svm_ext, '_segments.png']);
%    saveas(fig, [final_directory, '/', files(im).name, int2str(width), ...
%                 'x', int2str(height), svm_ext, '_segments.png']);
%    close(fig);
  end
end
