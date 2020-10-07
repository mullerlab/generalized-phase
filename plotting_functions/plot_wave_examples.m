function plot_wave_examples( x, options, trial, evaluation_points, source, rho )
% *SPONTANEOUS WAVES DEMO*
%
% PLOT WAVE EXAMPLES     plot specific examples of spontaneous waves based
%                          on calculated values of \rho_{\phi,d}
%
% INPUT
% x - datacube (rows,cols,timepts)
% options - options structure (cf. spontaneous_waves_demo.m)
% trial - trial number
% evaluation_points - evaluation time points (cf. find_evaluation_points)
% source - putative source point
% rho - calculated \rho_{\phi,d} values
%
% OUTPUT
% animated spatiotemporal plot
%

% parameters
plot_rho_value = 0.5; plot_time = 20; pause_length = 0.2; 

% init
M = load( './input/myMap.mat' );

ctr = 1; % wave detections counter
for jj = 1:length(evaluation_points)
    
    % animated wave plot
    if ( rho(jj) > plot_rho_value )
        
        % get start and stop time, truncating if necessary
        st = evaluation_points(jj) - plot_time; sp = evaluation_points(jj) + plot_time;
        if ( st < 1 ), st = 1; end; if ( sp > size(x,3) ), sp = size(x,3); end
        
        % get data to plot, shuffle if option is chosen
        x_plot = x(:,:,st:sp); 
        if ( options.plot_shuffled_examples == true ), x_plot = shuffle_channels( x_plot ); end        
        
        % create plot
        figure; title( sprintf( 'trial %d, wave example %d, 0 of %d ms', trial, ctr, size(x_plot,3) ) );
        color_range = [ min(reshape(x_plot,[],1)) max(reshape(x_plot,[],1)) ];
        h = imagesc( x_plot(:,:,1) ); hold on; axis image; 
        plot( source(1,jj), source(2,jj), '.', 'markersize', 35, 'color', [.7 .7 .7] );
        set( gca, 'linewidth', 3, 'xtick', [], 'ytick', [], 'fontname', 'arial', 'fontsize', 16, 'ydir', 'reverse' ); 
        colormap( M.myMap ); box on; xlabel( 'electrodes' ); ylabel( 'electrodes' ); caxis( color_range )
        
        % create colorbar
        cb = colorbar();
        if strcmp( options.subject, 'W' ) == true
            set( cb, 'location', 'southoutside' )
            set( cb, 'position', [0.6661    0.1674    0.2429    0.0588] );
        elseif strcmp( options.subject, 'T' ) == true
            set( cb, 'position', [0.8509    0.3857    0.0330    0.3167] );
        end
        set( get(cb,'ylabel'), 'string', 'Amplitude (\muV)' ); set( cb, 'linewidth', 2 )
        
        % animate plot
        for kk = 1:size(x_plot,3)
            set( h, 'cdata', x_plot(:,:,kk) ); 
            set( get(gca,'title'), 'string', ...
                sprintf( 'trial %d, wave example %d, %d of %d ms', trial, ctr, kk, size(x_plot,3) ) )
            pause(pause_length); 
        end
        
        % increment counter
        ctr = ctr + 1;
        
    end
end
