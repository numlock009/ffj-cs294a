function segment_image(directory, final_directory, height, width)
files = dir(directory)
for i= 1:size(files,1)
  if(~files(i).isdir)
    img = imread(strcat(directory, '/', files(i).name));
    [h, w, c] = size(img);
    for row =  1:height:(h-height)
      for col = 1:width:(w-width)
        im = imcrop(img, [col, row, height-1, width-1]);
        imwrite(im, strcat(final_directory, '/', 'cropped_', int2str(col), 'x', int2str(row),'_', files(i).name), ...
                'Quality', 100);
      end
    end
  end
end