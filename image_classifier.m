function [classifier] = image_classifier(train_images, feature)
train_examples = [];
train_categories = zeros(size(train_images,1), 1);
for i = 1:size(train_images,1)
  train_examples(i, :) = feature(train_images(i));
  % choose the following based on whether the image
  % came from the positive or negative directory 
  train_categories(i) = 1;
end

classifier = train(train_examples, train_categories);
