function train_svm(data, categories, trainfile, paramfile, regression)
option = svmlopt('ExecPath', './classifiers/svm/', 'Regression', regression);
svmlwrite( trainfile , data , categories  );
svm_learn( option, trainfile, paramfile );
