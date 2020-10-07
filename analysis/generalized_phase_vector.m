function [xgp,wt] = generalized_phase_vector( x, Fs, lp )
%
% GENERALIZED PHASE VECTOR    calculate the generalized phase of input vector
%
% INPUT:
% x - data column vector (t,1)
% Fs - sampling rate (Hz)
% lp - low-frequency data cutoff (Hz)
%
% OUTPUT:
% xgp - output datacube
% wt - instantaneous frequency estimate
%

% parameters
nwin = 3;

% handle input
assert( iscolumn(x), 'column vector input required' );
npts = length(x);

% anonymous functions
rewrap = @(xp) ( xp - 2*pi*floor( (xp-pi) / (2*pi) ) - 2*pi );
naninterp = @(xp) interp1( find(~isnan(xp)), xp(~isnan(xp)), find(isnan(xp)), 'pchip' );

% init
dt = 1 / Fs;

% analytic signal representation (single-sided Fourier approach, cf. Marple 1999)
xo = fft( x, npts, 1 ); h = zeros( npts, ~isempty(x) );
if ( npts > 0 ) && ( mod(npts,2) == 0 ), h( [1 npts/2+1] ) = 1; h(2:npts/2) = 2;
else, h(1) = 1; h(2:(npts+1)/2) = 2; end
xo = ifft( xo.*h(:,ones(1,size(x,2))), [], 1 );
ph = angle( xo ); md = abs( xo );

% calculate IF
wt = zeros(size(xo));
wt(1:end-1) = angle( xo(2:end) .* conj( xo(1:end-1) ) ) ./ (2*pi*dt);

% account for sign of IF
sign_if = sign( nanmean(wt(:)) );
if ( sign_if == -1 )
    modulus = abs(xo); ang = sign_if .* angle(xo); % rectify rotation
    xo = modulus .* exp( 1i .* ang ); ph = angle( xo ); md = abs( xo );
    wt(1:end-1) = angle( xo(2:end) .* conj( xo(1:end-1) ) ) ./ (2*pi*dt); % re-calculate IF
end

% check if nan channel
if all( isnan(ph) ), xgp = nan( size(xo) ); return; end

% find negative frequency epochs (i.e. less than LP cutoff)
idx = ( wt < lp ); idx(1) = 0; [L,G] = bwlabel( idx );
for kk = 1:G
    idxs = find( L == kk );
    idx( idxs(1):( idxs(1) + ((idxs(end)-idxs(1))*nwin) ) ) = true;
end

% "stitch over" negative frequency epochs
p = ph; p(idx) = NaN;
if all( isnan(p) ), xgp = nan( size(xo) ); return; end % check if all NaNs
p = unwrap(p); p(isnan(p)) = naninterp( p ); p = rewrap( p ); ph = p;

% output
xgp = md .* exp( 1i .* ph );
