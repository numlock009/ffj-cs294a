function points = read_points_from_file(points_files)
points = {}
for d = 1:size(points_files, 2)
  points{d} = {};
  fid = fopen(points_files{d}, 'r');
  image_num = 1;
  while(true)
    fname = fscanf(fid, '%s', 1);
    if(isempty(fname)), break, end;
    points{d}{image_num}{1} = fname;
    m = fscanf( fid , '%d' , [1 2]);
    keypoints = fscanf(fid , '%d' , m);
    keypoints = reshape(keypoints, [m(2) m(1)])';
    points{d}{image_num}{2} = keypoints;
    image_num = image_num + 1;
  end
  fclose(fid);
end
