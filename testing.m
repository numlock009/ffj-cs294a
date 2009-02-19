% image directory for positive training examples
% image directory for negative training examples
train_images;
feature = @image_features;
classifier = image_classifier(train_images, feature);
% image directory for positive testing examples
% image directory for negative testing examples
test_images;

% figure out how to load these
test_examples = [];
test_actual = zeros(size(test_images,1), 1);
for i = 1:size(test_images,1)
  test_examples(i, :) = feature(test_images(i));
  % choose the following based on whether the image
  % came from the positive or negative directory 
  test_actual(i) = 1;
end

for i = 1:size(test_examples, 1)
  classification(i) = classifier(test_examples(i));
end

% depends on the algorithm
pos = 1;
neg = 0;

num_correct = sum(classification == test_actual);
error = num_correct / size(test_examples, 1)
prec = precision(classification, test_actual, pos, neg)
rec = recall(classification, test_actual, pos, neg)