function getneghair_sunny( path )
files = dir(path);
num=10000;
for ii=1 : size(files,1)
    ii
    sf = strfind(files(ii).name, '.jpg');
    if( files(ii).isdir ~= 1 && size(sf, 1) > 0)
        im = imread(strcat(path, '\', files(ii).name));
        if ndims(im) > 2
            im = im2double(rgb2gray( im ));
        else
            im = im2double(im);
        end
        height = size(im, 1);
        width = size(im, 2);
        for i =  1: 50 : height - 50
            for j = 1: 50 : width - 50
                imcrop = im(i:i+49, j:j+49);
                num=num+1;
                a = num2str(num, '%4d');
                imwrite(imcrop, strcat('D:\Code\hair\hair_test_', a, '.jpg')); 
            end
        end
    end
end

num = 0;
filename = 'D:\Code\better-cropped-50pos-highres\cropped004a.jpg';
im = imread( filename );
if ndims(im) > 2
    im = im2double(rgb2gray( im ));
else
    im = im2double(im);
end
figure(100); imshow(im); hold on;
height = size(im, 1);
width = size(im, 2);
for i =  1: 50 : height - 50
    for j = 1: 50 : width - 50
        imcrop = im(i:i+49, j:j+49);
        num=num+1;
        a = num2str(num, '%4d');
        imwrite(imcrop, strcat('D:\Code\hair\cropped004a_', a, '.jpg'));
        text(j, i, a, 'Color', 'r');
    end
end
hold off;











