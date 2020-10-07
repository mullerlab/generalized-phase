function source = find_source_points( evaluation_points, X, Y, dx, dy )
% *SPONTANEOUS WAVE DEMO*
%
% FIND SOURCE POINTS     find "putative" source points - the most likely
%                          starting point for a wave on the mulichannel
%                          array by locating the arg max of divergence of a
%                          vector field at each evaluation time point
%
% INPUT
% evaluation_points - time points at which to locate sources
% X - x-coordinates for rectangular grid (cf. meshgrid)
% Y - y-coordinates for rectangular grid
% dx - vector field components along x-direction
% dy - vector field components along y-direction
%

d = nan( size(X,1), size(X,2), length(evaluation_points) );

for ii = 1:length(evaluation_points)
    d(:,:,ii) = divergence( X, Y, dx(:,:,evaluation_points(ii)), dy(:,:,evaluation_points(ii)) );
end
d = smoothn( d, 'robust' );

source = nan( 2, length(evaluation_points) );
for ii = 1:length(evaluation_points)    
    [yy,xx] = find( d(:,:,ii) == max( reshape(d(:,:,ii), 1, [] ) ) );
    if numel(yy) == 1
        source(1,ii) = xx; source(2,ii) = yy;
    else
        source(1,ii) = NaN; source(2,ii) = NaN; 
    end
end
