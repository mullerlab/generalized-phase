function ep = find_evaluation_points( r, evaluation_angle, tol )
% *SPONTANEOUS WAVE DEMO*
%
% FIND EVALUATION POINTS     find points at which the phase distribution
%                              over channels passes a specified angle
%                              (within numerical tolerance "tol")
%
% INPUT
% r - phase datacube (rows, cols, timepts)
% evaluation_angle - angle to evaluate phase crossing [rad]
% tol - numerical tolerance [rad]

r = reshape( r, size(r,1)*size(r,2), [] ); r = nansum( r, 1 ) ./ size(r,1);
r = abs( circ_dist( angle(r), evaluation_angle ) );
dr = find( diff( sign( diff(r) ) ) == 2 ) + 1;
ep = dr( abs(r(dr)) < tol );
