function test_model( pos_directory , neg_directory ,posfile , negfile, cellsize , ori_binsize , dist_binsize , testfile , paramfile , predictfile , maxsize)
%mostly the same as process
[ min1  min2 ] = findAllKeypoints( pos_directory , posfile );
[ min3  min4 ] = findAllKeypoints( neg_directory , negfile);
posData = readAndGenerate( pos_directory , posfile , maxsize , cellsize , ori_binsize , dist_binsize  );
posY = ones( size(posData,1) ,1);
%min1
negData = readAndGenerate( neg_directory , negfile , maxsize , cellsize , ori_binsize , dist_binsize  );
negY =-1 * ones( size(negData,1) ,1);
%min3
option = svmlopt('ExecPath', 'svm/');
svmlwrite( testfile , [posData ; negData] , [posY ; negY]  );
svm_classify(option, testfile , paramfile , predictfile );