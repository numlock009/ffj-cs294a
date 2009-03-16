function points = read_points(fid)
m = fscanf( fid , '%d' , [1 2]);
points = fscanf(fid , '%d' , m);
points = reshape(points, [m(2) m(1)])';
