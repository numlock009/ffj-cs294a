function error = err(classification, actual)
error=0;
numTestDocs = size(classification,1);
for i=1:numTestDocs
  if (actual(i) ~= classification(i))
    error=error+1;
  end
end
error = error/numTestDocs;