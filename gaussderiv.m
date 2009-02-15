function dx = gaussderiv(width, sigma)
st = round(width*sigma); % go width std's away up or down.
x  = -st:st;
dx = x .* exp(-x.*x/(2*sigma^2)) ./ ((sigma^3)*sqrt(2*pi));
