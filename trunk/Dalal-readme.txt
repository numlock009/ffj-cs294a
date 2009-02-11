How to use Dalal-Triggs?

The two files uploaded are the only ones necessary to run Dalal-Triggs, the first one is Dalal-Triggs and the second one is a variation of block processing function(blkproc) in MATLAB.

to call Dalal-Triggs:

DalalTriggs(image_file_path , image_width , image_length , scale )

image_width and image_length are the width and length of the central window that we want dalal-triggs to look into it, and scale determines the amount that we want to scale our image if it is so large.
it will return a feature vector.

to use it for classifying images, you should call it on all your training data, extract features out of data and give them to svm_learn to learn SVM parameters , do the same on test images and give them to svm_classify along with SVM parameters to calssify them.

I'm uploading the SVM_light wrapper, if you downlaod SVM_light version 4.00 you can use the functions mentioned above.
