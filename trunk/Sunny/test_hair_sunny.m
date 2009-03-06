function test_hair_sunny

option = svmlopt();

filename = 'D:\Code\better-cropped-50pos-highres\cropped004a.jpg';
im = imread(filename);
if ndims(im) > 2
    im = im2double(rgb2gray( im ));
else
    im = im2double(im);
end
height = size(im, 1);
width = size(im, 2);

premat = [];
testinput = [];
for i =  1: 50 : height - 49
    i
    for j = 1: 50 : width - 49
        premat = [premat; [j+25, i+25, 50-25, 50-25]];
        imcrop = im(i:i+49, j:j+49);
        testfeature = sift_wf( imcrop );
        testele = zeros(1, 200);
        for itest = 1:size(testfeature, 1)
            mindist = intmax;
            minj = 0;
            for jtest = 1:200
                dist = sum( (testfeature(itest, 1:128) - centroids(jtest, 1:128)).^2 );
                if (dist < mindist)
                    mindist = dist;
                    minj = jtest;%set its centroids index
                end
            end
            testele(1, minj) = testele(1, minj) + 1;
        end
        testinput = [testinput; testele];
    end
end
result(1:size(testinput, 1)) = -1;
if size(result, 1) == 1
    result = result';
end

%% learn and predict using SVM
svmlwrite( 'testmat' , testinput , result  );
svm_classify(option, 'testmat', 'model' , 'predict.txt');

fid = fopen('predict.txt', 'r');
predict = fscanf(fid, '%g', [1 inf]);    % It has two rows now.
predict = predict';
fclose(fid);

figure(100); imshow(im); hold on;
for i = 1:size(predict, 1)
    if predict(i) > 0
        rectangle('Position', premat(i,:), 'LineWidth', 3, 'EdgeColor', [1, 0.4, 0.6]);
    end
end
hold off;

toc
