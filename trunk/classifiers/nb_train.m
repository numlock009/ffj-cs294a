function [negatives, positives, lp_not, lp_hot, bow_info_gainer, MI_gain] = nb_train(trainMatrix, trainCategory)
% [trainMatrix, trainCategory] = readMatrix(train_file);

numTrainDocs = size(trainMatrix, 1);
numTokens = size(trainMatrix, 2);

% trainMatrix is now a (numTrainDocs x numFeatures) matrix.
% Each row represents a unique face.
% The j-th column of the row $i$ represents the jth feature of email $i$

% trainCategory is a (numTrainDocs x 1) vector containing the true 
% classifications for the documents just read in. The i-th entry gives the 
% correct class for the i-th email (which corresponds to the i-th row in 
% the document word matrix).

% Spam documents are indicated as class 1, and non-spam as class 0.
% Note that for the SVM, you would want to convert these to +1 and -1.


negatives = trainMatrix( find(trainCategory == 0)', :);
positives = trainMatrix( find(trainCategory == 1)', :);

totalWordsInNegatives = sum(sum(negatives));
totalWordsInPositives = sum(sum(positives));

lp = zeros(2, numTokens);
lp(1, :) = log(sum(negatives) + 1) - log(totalWordsInNegatives + numTokens);
lp(2, :) = log(sum(positives) + 1) - log(totalWordsInPositives + numTokens);

lp_not = @(sample)( lp(1, :)*sample' );
lp_hot = @(sample)( lp(2, :)*sample' );

bow_info_gainer = @(feature)(lp(2, feature) - lp(1, feature));

wordCounts(1, :) = sum(negatives) + 1;
wordCounts(2, :) = sum(positives) + 1;
numPerWord = sum(wordCounts);
N(1) = sum(wordCounts(1, :));
N(2) = sum(wordCounts(2, :));
numWords = sum(N);

MI = zeros(2, numTokens);
for i=1:2
  MI(i, :) = ((wordCounts(i, :)/numWords) .* log((wordCounts(i, :)./(numPerWord)) ...
                                                 / (N(i)/numWords)))...
      + (((N(i) - wordCounts(i, :))/numWords) .* ...
         log(((N(i) - wordCounts(i, :)) ./(numWords - numPerWord)) ...
             / (N(i)/numWords)));
end
MI_gain = @(feature)(MI(2, feature) + MI(1,feature));