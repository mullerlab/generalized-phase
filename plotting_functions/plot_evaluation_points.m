function plot_evaluation_points( x, evaluation_points )
% *SPONTANEOUS WAVES DEMO*
%
% PLOT EVALUATION POINTS     plot calculated evaluation points over the set
%                              of channels in a multielectrode array
%
% INPUT
% x - datacube (rows,cols,timepts)
% evaluation_points - evaluation time points (cf. find_evaluation_points)
%
% OUTPUT
% plot with channels (gray) and evaluation points (red lines)
%

% init
channels = size(x,1)*size(x,2);

% plot channels
fg1 = figure; pos = get( fg1, 'position' ); set( fg1, 'position', [pos(1) pos(2) 1200 420] ); hold on;
plot( real(reshape(x,channels,[]))', 'color', [.5 .5 .5], 'linewidth', 2 ); yl = ylim;
set( gca, 'fontname', 'arial', 'fontsize', 18, 'linewidth', 2, 'ytick', yl(1):40:yl(end) );
xlabel( 'Time (ms)' ); ylabel( 'Amplitude (\muV)' );

% plot evaluation points
for ii = 1:length(evaluation_points)
    l = line( [ evaluation_points(ii) evaluation_points(ii) ], yl );
    set( l, 'color', 'r' ); uistack( l, 'bottom' ); axis tight
end
