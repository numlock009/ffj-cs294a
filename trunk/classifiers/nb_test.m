function [classification_error, output] = nb_test(testMatrix, category, hypothesis_function)

numTestDocs = size(testMatrix, 1);
numTokens = size(testMatrix, 2);

% Construct the (numTestDocs x 1) vector 'output' such that the i-th entry 
% of this vector is the predicted class (1/0) for the i-th  email (i-th row 
% in testMatrix) in the test set.
output = zeros(numTestDocs, 1);

for i=1:numTestDocs
  output(i) = hypothesis_function(testMatrix(i, :));
end

%Print out the classification error on the test set
classification_error = err(output, classification)
prec = precision(output, category, 1, 0)
rec = recall(output, category, 1, 0)