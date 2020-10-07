%
% generalized phase (GP) demo
% lyle muller
% 18 february 2020
%

clearvars; clc

% load example channel
load( './data/exampleChannel.mat' );

% parameters
filter_order = 4; Fs = 1000; lp = 0;
dt = 1 / Fs; T = length(x) / Fs; time = dt:dt:T;

% preprocessing - lowpass + notch
[b,a] = butter( 4, [5 200] ./ (Fs/2) ); xw = filtfilt( b, a, x ); 
[b,a] = butter( 4, [58 62] ./ (Fs/2), 'stop' ); xw = filtfilt( b, a, xw ); 
[b,a] = butter( 4, [115 125] ./ (Fs/2), 'stop' ); xw = filtfilt( b, a, xw );

% create GP
[b,a] = butter( filter_order, [5 40] ./ (Fs/2) ); xf = filtfilt( b, a, x ); 
xgp = generalized_phase_vector( xf, Fs, lp );

%% plot - wideband LFP and GP

% main figure
fg1 = figure; hold on; ax1 = gca; set( fg1, 'position', [ 88  1593  1250  420 ] )
plot( time, xw, 'linewidth', 4, 'color', 'k' ); h4 = cline( time, xf, [], angle(xgp) );
set( h4, 'linestyle', '-', 'linewidth', 5  ); xlim( [0.06 .65] ); axis off
l1 = line( [.1 .2], [-125 -125] ); set( l1, 'linewidth', 4, 'color', 'k' )
l2 = line( [.1 .1], [-125 -75] ); set( l2, 'linewidth', 4, 'color', 'k' )

% inset
map = colorcet( 'C2' ); colormap( circshift( map, [ 28, 0 ] ) )
ax2 = axes; set( ax2, 'position', [0.2116    0.6976    0.0884    0.2000] ); axis image
[x1,y1] = pol2cart( angle( exp(1i.*linspace(-pi,pi,100)) ), ones( 1, 100 ) );
h3 = cline( x1, y1, linspace(-pi,pi,100) ); axis off; set( h3, 'linewidth', 6 )

% text labels
t1 = text( 0, 0, 'GP' );
set( t1, 'fontname', 'arial', 'fontsize', 28, 'fontweight', 'bold', 'horizontalalignment', 'center' )
set( gcf, 'currentaxes', ax1 )
t2 = text( 0.1260, -146.8832, '100 ms' );
set( t2, 'fontname', 'arial', 'fontsize', 24, 'fontweight', 'bold' )
t2 = text( 0.0852, -130.2651, '50 \muV' );
set( t2, 'fontname', 'arial', 'fontsize', 24, 'fontweight', 'bold', 'rotation', 90 )
