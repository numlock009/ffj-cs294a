function allData = readAndGenerate( directory , points_file , max_points , cellsize , ori_binsize , dist_binsize  )
%reads all the key points from file and generates descriptors for each
%keypoint
fid = fopen( points_file , 'r');
datasize = fscanf( fid , '%d' , 1);
index =1 ;
files = dir( directory );
for i=1 : datasize
  m = fscanf( fid , '%d' , [ 1 2] );
  keypoints = fscanf(fid , '%d' , m);
  for j=1 : max_points
    descriptor = RIFT_descriptor( prepare_image( strcat(directory , files(i+2).name) ) , keypoints(j,1) , keypoints(j,2) , cellsize , ori_binsize , dist_binsize );
    allData(index , :) = reshape( descriptor , 1, size(descriptor,1) * size(descriptor,2));
    index = index+1;
  end
end