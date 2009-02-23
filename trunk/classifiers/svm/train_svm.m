function train_svm(data, categories, trainfile, paramfile)
option = svmlopt('ExecPath', './classifiers/svm/');
svmlwrite( trainfile , data , categories  );
svm_learn( option, trainfile, paramfile );
