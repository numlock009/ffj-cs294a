function [ result ] = do_conv( image , def_kernel )
FFTim = fft2(image);

kernel=zeros(size(image));
kernel( 1: size(def_kernel,1) , 1:size(def_kernel ,2)) = def_kernel;
FFTkernel = fft2(kernel);

% apply the kernel and check out the result
FFTresult = FFTim .* FFTkernel;
result = real(ifft2(FFTresult));
