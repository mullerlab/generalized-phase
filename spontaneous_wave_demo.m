%
% generalized phase demo
% lyle muller + zac davis
% 1 september 2020
%

% set up paths to WAVE and subdirectories
addpath( genpath_exclude( '~/Software/matlab/wave-matlab', '.git' ) )
addpath( genpath_exclude( '.', '.git' ) ); 
clearvars; clc;

% options
options.subject = 'T'; % this can be 'W' or 'T' (two marmoset subjects)
options.plot = true; % this option turns plots ON or OFF
options.plot_shuffled_examples = false; % example plots w/channels shuffled in space

% parameters
parameters.Fs = 1000; % data sampling rate [Hz]
parameters.filter_order = 4; parameters.f = [5 40]; % filter parameters
parameters.start_time = -300; % time point to start analysis
parameters.stop_time = 0; % stop analysis (relative to target onset)
parameters.pixel_spacing = 0.4; % spacing between electrodes [mm]
parameters.lp = 0; % cutoff for negative frequency detection [Hz]
parameters.evaluation_angle = pi; parameters.tol = 0.2; % evaluation points

% load data
data = load_data( './data/exampleData.mat', options ); trials = length( data );
[rows,cols,~] = size( data(1).x ); channels = rows*cols;
[X,Y] = meshgrid( 1:cols, 1:rows ); % create grid

% analysis loop
spike_phase = [];
for ii = 1:trials
    
    % analysis times (during fixation, prior to target onset)
    start_time = data(ii).target_onset + parameters.start_time;
    stop_time = data(ii).target_onset + parameters.stop_time;
    
    % wideband filter
    xf = bandpass_filter( data(ii).x, parameters.f(1), parameters.f(2), ...
        parameters.filter_order, parameters.Fs );
    
    % GP representation
    xgp = generalized_phase( xf, parameters.Fs, parameters.lp );
    p = xgp(:,:,start_time:stop_time); 
    
    % find evaluation points
    evaluation_points = ...
        find_evaluation_points( p, parameters.evaluation_angle, parameters.tol );
    
    % plotting 1 - evaluation points
    if options.plot, plot_evaluation_points( p, evaluation_points ); end
    
    % calculate phase gradient
    [pm,pd,dx,dy] = phase_gradient_complex_multiplication( p, parameters.pixel_spacing );
    
    % divergence calculation
    source = find_source_points( evaluation_points, X, Y, dx, dy );
    
    % phase correlation with distance (\rho_{\phi,d} measure)
    rho = zeros( 1, length(evaluation_points) );
    for jj = 1:length(evaluation_points)
        
        ph = angle( p(:,:,evaluation_points(jj)) );
        if strcmp( options.subject, 'T' ); ph(data(1).mask) = NaN; end
        rho(jj) = phase_correlation_distance( ph, source(:,jj), parameters.pixel_spacing );
        
    end
    
    % plotting 2 - wave examples
    if options.plot, plot_wave_examples( xf(:,:,start_time:stop_time), options, ii, evaluation_points, source, rho ); end
    
    % spike-GP analysis
    for kk = 1:rows
        for ll = 1:cols
            spike_times = data(ii).spikes{kk,ll} + data(ii).target_onset;
            spike_phase = [ spike_phase squeeze(angle(xgp(kk,ll,floor(spike_times))))' ]; %#ok<AGROW>
        end
    end
        
end

%% plotting 3 - spike-GP coupling

fg1 = figure; histogram( spike_phase, linspace(-pi,pi,11), 'normalization', ...
    'probability', 'facecolor', 'k', 'linewidth', 1.5 )
set( gca, 'fontname', 'arial', 'fontsize', 18, 'linewidth', 2 ); box off
xlabel( 'Generalized phase (rad)' ); ylabel( 'Fraction of spikes' )
set( gca, 'xtick', [-pi -pi/2 0 pi/2 pi], 'xticklabel', {'-\pi','-\pi/2','0','\pi/2','\pi'} )
title( [ 'Monkey ' options.subject ' spike-GP coupling' ] )
