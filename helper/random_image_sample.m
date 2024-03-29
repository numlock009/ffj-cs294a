% directory contains the image files we want to crop

function [] = random_image_sample(directory, final_directory, height, width)
files = dir(directory);
for i=1 : min(600, size(files,1))
  if(~files(i).isdir)
    img = imread(strcat(directory,'/', files(i).name));
    [h, w, c] = size(img);
    row = randperm(h - 2*height);
    col = randperm(w - 2*width);
    for j = 1:15
      im = imcrop(img, [col(j), row(j), width-1, height-1]);
      imwrite(im, strcat(final_directory, '/', 'cropped_', int2str(j),'_', files(i).name), ...
              'Quality', 100);
    end
  end
end