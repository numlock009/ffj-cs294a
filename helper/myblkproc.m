function b = myblkproc(A, W ,M , N , M1 , N1, fun , bins)
   
%[a, block, border, fun, params, padval] = parse_inputs(varargin{:});
block=[M N];
border=[M1 N1];
% Expand A: Add border, pad if size(a) is not divisible by block.
a=A;
w=W;
[ma,na] = size(a);
mpad = rem(ma,block(1)); if mpad>0, mpad = block(1)-mpad; end
npad = rem(na,block(2)); if npad>0, npad = block(2)-npad; end
if (isa(a, 'uint8'))
        aa = repmat(uint8(0), ma+mpad+2*border(1),na+npad+2*border(2));
        ww = repmat(uint8(0), ma+mpad+2*border(1),na+npad+2*border(2));

elseif isa(a, 'uint16')
        aa = repmat(uint16(0), ma+mpad+2*border(1),na+npad+2*border(2));
        ww = repmat(uint16(0), ma+mpad+2*border(1),na+npad+2*border(2));
else
        aa = zeros(ma+mpad+2*border(1),na+npad+2*border(2));
        ww = zeros(ma+mpad+2*border(1),na+npad+2*border(2));
end
aa(border(1)+(1:ma),border(2)+(1:na)) = a;
ww(border(1)+(1:ma),border(2)+(1:na)) = w;

m = block(1) + 2*border(1);
n = block(2) + 2*border(2);
mblocks = (ma+mpad)/block(1);
nblocks = (na+npad)/block(2);
arows = 1:m; acols = 1:n;
x = aa(arows, acols);
wx= ww(arows, acols);
firstBlock = feval(fun,x,wx,bins);
if (isempty(firstBlock))
  style = 'e'; % empty
  b = [];
elseif (all(size(firstBlock) == size(x)))
  style = 's'; % same
  % Preallocate output.
  if (isa(firstBlock, 'uint8'))
     b = repmat(uint8(0), ma+mpad, na+npad);
  elseif (isa(firstBlock, 'uint16'))
     b = repmat(uint16(0), ma+mpad, na+npad);
  else
     b = zeros(ma+mpad, na+npad);
  end
  brows = 1:block(1);
  bcols = 1:block(2);
  mb = block(1);
  nb = block(2);
  xrows = brows + border(1);
  xcols = bcols + border(2);
  b(brows, bcols) = firstBlock(xrows, xcols);
elseif (all(size(firstBlock) == (size(x)-2*border)))
  style = 'b'; % border
  % Preallocate output.
  if (isa(firstBlock, 'uint8'))
      b = repmat(uint8(0), ma+mpad, na+npad);
  elseif (isa(firstBlock, 'uint16'))
      b = repmat(uint16(0), ma+mpad, na+npad);
  else
      b = zeros(ma+mpad, na+npad);
  end
  brows = 1:block(1);
  bcols = 1:block(2);
  b(brows, bcols) = firstBlock;
  mb = block(1);
  nb = block(2);
else
  style = 'd'; % different
  [P,Q] = size(firstBlock);
  brows = 1:P;
  bcols = 1:Q;
  mb = P;
  nb = Q;
  if (isa(firstBlock, 'uint8'))
      b = repmat(uint8(0), mblocks*P, nblocks*Q);
  elseif (isa(firstBlock, 'uint16'))
      b = repmat(uint16(0), mblocks*P, nblocks*Q);
  else
      b = zeros(mblocks*P, nblocks*Q);
  end
  b(brows, bcols) = firstBlock;
end

[rr,cc] = meshgrid(0:(mblocks-1), 0:(nblocks-1));
rr = rr(:);
cc = cc(:);
mma = block(1);
nna = block(2);
for k = 2:length(rr)
  x = aa(rr(k)*mma+arows,cc(k)*nna+acols);
  wx = ww(rr(k)*mma+arows,cc(k)*nna+acols);
  c = feval(fun,x,wx,bins);
  if (style == 's')
    b(rr(k)*mb+brows,cc(k)*nb+bcols) = c(xrows,xcols);
  elseif (style == 'b')
    b(rr(k)*mb+brows,cc(k)*nb+bcols) = c;
  elseif (style == 'd')
    b(rr(k)*mb+brows,cc(k)*nb+bcols) = c;
  end
end

if ((style == 's') || (style == 'b'))
  b = b(1:ma,1:na);
end
