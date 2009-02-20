train_images;
feature = @image_features;
classifier = image_classifier(train_images, feature);
threshold = 0.7; % set a threshold for whatever the classifier returns?
img;
d = 0;
detections = zeros(1, 5);
for i = 1:size(img, 1)
  im = imread(img(i));
  % find keypoints, find descriptors
  keypts = get_keypoints_wrapper(im);
  descriptors = descriptors_wrapper(im, keypts);
  for x=1:m:size(im,2)
    for y=1:n:size(im,1)
      for w=1:dm:(size(im,2) - x)
        for h=1:dn:(size(im,1) - y)
          window = [x, y, w, h];
          h = classifier(window_feature(im, window, keypts, descriptors, ...
                                        feature))
          if( h > threshold)
            d = d + 1;
            detections(d, :) = [window, h];
          end
        end
      end
    end
  end
end
