function  process( pos_directory , neg_directory ,posfile , negfile, cellsize , ori_binsize , dist_binsize , trainfile , paramfile)
%train an SVM on training data, inputs are:
% pos_directory : the path of directory containing positive tarining examples
% neg_directory : the path of directory containing negative tarining
%      examples
% posfile : when positive example key points are computed using a key point detector
%      they are saved in the file named posfile -- this is useful when you want to 
%      test different descriptors with one ke point detector , so once you
%      computed key points they are saved and you can use them from then
% negfile : use it the same as posfile for negative examples
% tarinfile: the file in which the training data descriptors will be saved
% paramfile: the file in which parameters of the trained SVM will be saved
% cell size: is the size of region selected around each key point
% ori_binsize : along with RIFT can be used to determine number of
% orientation bins and along with spin images it is used to determine
% number of intensity bins
% dist_binsize: determine the number of circular rings that we're
% considering aroung the key point
[ min1  min2 ] = findAllKeypoints( pos_directory , posfile);
[ min3  min4 ] = findAllKeypoints( neg_directory , negfile);
maxsize = min( min1 , min3 )
%maxsize = 98;
posData = readAndGenerate( pos_directory , posfile , maxsize , cellsize , ori_binsize , dist_binsize  );
posY = ones( size(posData,1) ,1);
%min1
negData = readAndGenerate( neg_directory , negfile , maxsize , cellsize , ori_binsize , dist_binsize  );
negY =-1 * ones( size(negData,1) ,1);
%min3
option = svmlopt('ExecPath', 'svm/');
svmlwrite( trainfile , [posData ; negData] , [posY ; negY]  );
svm_learn( option ,trainfile ,  paramfile );