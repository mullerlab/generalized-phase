function channel_map = channel_mapping( subject )
%
% CHANNEL MAPPING
%
% INPUTS
% subject - 'W' | 'T'
%
% OUTPUTS
% channel_map - 2d array of channel numbers (rows, cols)
%

if strcmp( subject, 'W' )
      
    % subset of MT channels
    channel_map = ...
        [ 45    53    36    60    13    21     4    28;
          46    54    35    59    14    22     3    27;
          47    55    34    58    15    23     2    26;
          48    56    33    57    16    24     1    25; ];


elseif strcmp( subject, 'T' )

    channel_map = ...
        [ NaN     4   NaN    22   NaN    31   NaN     9   NaN;
            8   NaN    18   NaN    27   NaN    13   NaN    36;
          NaN     3   NaN    23   NaN    32   NaN    40   NaN;
            7   NaN    19   NaN    28   NaN    12   NaN    35;
          NaN     2   NaN    24   NaN    16   NaN    39   NaN;
            6   NaN    20   NaN    29   NaN    11   NaN    34;
          NaN     1   NaN    25   NaN    15   NaN    38   NaN;
            5   NaN    21   NaN    30   NaN    10   NaN    33;
          NaN    17   NaN    26   NaN    14   NaN    37   NaN; ];

end
