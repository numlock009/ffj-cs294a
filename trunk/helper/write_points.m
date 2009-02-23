function write_points(fid , a )
for i=1:size(a,1)
  for j=1 : size(a,2)
    fprintf(fid, '%d\t',a(i,j));
  end
  fprintf(fid,'\n');
end