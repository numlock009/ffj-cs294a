function [classifier] = train_classifier(cl_algo, data, categories, varargin)
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('cl_algo', @(x) true);
p.addRequired('data', @(x) true);
p.addRequired('categories', @(x) true);
p.addParamValue('trainfile', 'svm_train_file', @ischar);
p.addParamValue('paramfile', 'svm_param_file', @ischar);
p.parse(cl_algo, data, categories, varargin{:});

% ASSUMPTION
% 
% categories is 1 for positive examples and -1 for negative examples
% if we are training a multiclass classifier the below will currently fail.

switch lower(cl_algo)
 case {'nb', 'naive_bayes'}
  % naive bayes classifier, has mutual information and bag of words
  % information gain functions as well, if we want to use these
  cat_1_0 = (categories + 1)/2;
  [negatives, positives, lp_not, lp_hot, bow_info_gainer, MI_gain] = ...
      nb_train(data, cat_1_0);
  h_fn = @(sample)(log(size(negatives, 1)) + lp_not(sample) < ...
                   log(size(positives, 1)) + lp_hot(sample))
  classifier = @(tdata, tcat, testfile, predictfile)(nb_test(tdata, tcat, ...
                                                  h_fn));
 case 'svm'
  % make the call to our classifier
  % make the call to svmlight using the matlab wrapper
  trainfile = p.Results.trainfile
  paramfile = p.Results.paramfile
  
  train_svm( data, categories, trainfile, paramfile);
  classifier = @(tdata, tcat, testfile, predictfile)(test_svm(tdata, tcat, paramfile, testfile, predictfile));
 otherwise
  disp('Unknown classifier')
end  
