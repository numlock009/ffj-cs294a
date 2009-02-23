function [classification_error, output] = test_svm(data, categories, paramfile, testfile, predictfile)
option = svmlopt('ExecPath', './classifiers/svm/');
svmlwrite( testfile , data , categories );
svm_classify(option, testfile , paramfile , predictfile);

output = zeros(size(data,1), 1);
fid = fopen(predictfile, 'r');
i = 0;
while(true)
  x = fscanf(fid, '%f', 1);
  if(isempty(x)), break, end
  i = i + 1;
  output(i) = x;
end
fclose(fid);

sgn = @(x)((x > 0) - (x <= 0)); % like the sign function but takes zero
                                % to -1 and not 0;
classification_error = err(sgn(output), categories);