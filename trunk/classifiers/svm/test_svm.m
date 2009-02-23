function test_svm(data, categories, paramfile, testfile, predictfile)
option = svmlopt('ExecPath', './classifiers/svm/');
svmlwrite( testfile , data , categories );
svm_classify(option, testfile , paramfile , predictfile );