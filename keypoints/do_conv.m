function [ result ] = do_conv( image , def_kernel )
FFTim = fft2(image);
FFTkernel = fft2(def_kernel, size(image, 1), size(image, 2));

% apply the kernel and check out the result
FFTresult = FFTim .* FFTkernel;
result = real(ifft2(FFTresult));
