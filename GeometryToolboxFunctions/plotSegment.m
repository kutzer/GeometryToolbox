function plt = plotSegment(varargin)
% PLOTSEGMENT plots a segment
%   plt = plotSegment(seg)
%   plt = plotSegment(axs,seg)
%
%   Input(s)
%       axs - [OPTIONAL] parent object for the plotted segment
%       seg - 2x2 array defining segment coefficients
%
%   Output(s)
%       plt - line object defining segment
%
%   M. Kutzer, 23Oct2025, USNA

%% Check input(s)
narginchk(1,2);
if nargin < 2
    seg = varargin{1};
    axs = gca;
else
    axs = varargin{1};
    seg = varargin{2};
end

% TODO - check inputs

%% Define end-points
pnts = seg*[0,1;1,1];

%% Plot segment 
% TODO - allow user to specify plotting options
plt = plot(axs,pnts(1,:),pnts(2,:),'-m');
