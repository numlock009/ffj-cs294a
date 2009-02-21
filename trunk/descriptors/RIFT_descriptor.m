function descriptor = RIFT_descriptor( image , key_x , key_y , cellsize , ori_binsize , dist_binsize )
cell = image( key_x - floor(cellsize/2): key_x + floor(cellsize/2) , key_y - floor(cellsize/2): key_y + floor(cellsize/2));
ori_bins = linspace( -pi/2 , pi/2 , ori_binsize );
dist_bins = linspace(1 , floor(cellsize/2)+3 , dist_binsize);
descriptor = zeros( ori_binsize , dist_binsize );
gradkernel = [-1 0 1 ];
dx = conv2( cell , gradkernel , 'same');
dx = dx + eps .* ones(size(dx));
dy = conv2( cell , gradkernel' , 'same');
cell_ori = atan(dy ./ dx);
cell_mag = sqrt( dx .^2 + dy .^ 2);
for i=1 : size(cell,1)
    for j=1 : size(cell,2)
        ori_indices = find( ori_bins >= cell_ori(i,j));
        dist = floor(sqrt((i-floor(cellsize/2)-1) .^ 2 + (j-floor(cellsize/2)-1) .^ 2));
        dist_indices = find( dist_bins >= dist );
        descriptor( ori_indices(1) , dist_indices(1)) = descriptor( ori_indices(1) , dist_indices(1)) + cell_mag(i,j);
    end
end