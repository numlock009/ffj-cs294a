function [ min1  min2 ] = findAllKeypoints( directory , filename)
files = dir(directory);
fid = fopen(filename , 'w');
fprintf(fid, '%d\n',size(files,1)-2);
min1 = 1000000;
min2 = 1000000;
for i=3 : size(files,1)
    points = harris_corner(imread(strcat(directory , files(i).name)),0.04,1);
    min1 = min( min1 , size(points,1));
    min2 = min( min2 , size(points,2));
    fprintf(fid, '%d\t',size(points,1));
    fprintf(fid, '%d\n',size(points,2));
    write_points(fid , points);
end
