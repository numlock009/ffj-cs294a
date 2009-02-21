function descriptor = spin( img , key_x , key_y , cellsize , intens_binsize , dist_binsize )
cell = img( key_x - floor(cellsize/2): key_x + floor(cellsize/2) , key_y - floor(cellsize/2): key_y + floor(cellsize/2));
dist_bins = linspace(1 , floor(cellsize/2)+3 , dist_binsize);
intensity_bins = linspace( 0 , 1 , intens_binsize );
descriptor = zeros( intens_binsize , dist_binsize );
for i=1 : size(cell,1)
    for j=1 : size(cell,2)
        dist = sqrt((i-floor(cellsize/2)-1) .^ 2 + (j-floor(cellsize/2)-1) .^ 2);
        dist_indices = find( dist_bins >= dist );
        intens_indices = find( intensity_bins >= cell(i,j) );
        descriptor( intens_indices(1) , dist_indices(1)) = descriptor( intens_indices(1) , dist_indices(1)) + 1;
	%here I'm using histogramming only , but in original papar
        %  as i emailed to you they use a soft function
	% just try this one! we'll do something for the soft one after
        % all your testing
    end
end
