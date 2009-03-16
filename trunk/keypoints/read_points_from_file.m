function points = read_points_from_file(points_file)
points = {};
fid = fopen(points_file, 'r');
image_num = 1;
while(true)
  fname = fscanf(fid, '%s', 1);
  if(isempty(fname)), break, end;
  points{image_num}{1} = fname;
  points{image_num}{2} = read_points(fid);
  image_num = image_num + 1;
end
fclose(fid);
