function data = load_data( filename, options )
% *SPONTANOEUS WAVES DEMO*
%
% LOAD DATA     load LFP and spikes from SNL-R Utah array recordings
%
% INPUT
% filename - /path/to/file
% options - options structure (cf. spontaneous_waves_demo.m)
%
% OUTPUT
% data(trial).x - datacube (rows,cols,timepts)
% data(trial).spikes - spike times {rows,cols}
% data(trial).fix_onset - onset time of fixation
% data(trial).target_onset - time of target onset
%
% RANKING CRITERIA FOR SINGLE UNITS
% 1 - isolated single unit, 2 - mostly single unit, 3 - multiunit,
% 4 - dubious, 5 - electrical noise and hash

% collect only units w/score "unitFilt" and below
unitFilt = 2;

% load data
S = load( filename );
channel_map = channel_mapping( options.subject );
rows = size( channel_map, 1 ); cols = size( channel_map, 2 );

% select trials from subject
S.exampleData = S.exampleData( [S.exampleData.ID] == options.subject );
trials = length( S.exampleData ); timepts = size( S.exampleData(1).LFP, 2 );

% init
data = struct([]);

for ii = 1:trials
    
    % clean up workspace
    clear x
    
    % create 3D array: data
    x = nan( rows, cols, timepts );
    for rr = 1:rows
        for cc = 1:cols
            if ~isnan( channel_map(rr,cc) )
                x(rr,cc,:) = S.exampleData(ii).LFP( channel_map(rr,cc), : );
            end
        end
    end
    
    % interpolate channels in monkey T's array (and save exclusion mask, so
    % that no interpolated data are later used as stastistical evidence)
    if strcmp( options.subject, 'T' ) == true
        data(1).mask = isnan( x(:,:,1) );
        for jj = 1:size(x,3), x(:,:,jj) = inpaint_nans(x(:,:,jj)); end
    end
    
    % load spikes
    spikes = S.exampleData(ii).Spikes; trial_spikes = cell( rows, cols );
    for jj = 1:length(spikes)
        
        [idx_row,idx_col] = find( channel_map == jj );
        if ( ~isempty(idx_row) && ~isempty(idx_col) )
            
            channel_spikes = spikes{jj}; spike_times = [];
            
            for kk = 1:size(channel_spikes,1)
                if channel_spikes{kk,2} <= unitFilt
                    spike_times = vertcat( spike_times, channel_spikes{kk,1} ); %#ok<AGROW>
                end
            end
            
            trial_spikes{idx_row,idx_col} = spike_times;
            
        end
        
    end
    
    % save data
    data(ii).x = x;
    data(ii).fix_onset = S.exampleData(ii).FixOn;
    data(ii).target_onset = S.exampleData(ii).TargOn;
    data(ii).spikes = trial_spikes;
    
end
