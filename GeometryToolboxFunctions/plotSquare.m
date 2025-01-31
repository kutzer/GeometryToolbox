function h = plotSquare(varargin)
% PLOTRECTANGLE plots a square in 3D
%   h = plotSquare(rfit) plots a square in the current axes
%
%   h = plotSquare(axs,___)
%
%   Inputs:
%        axs - *optional* handle of the parent of the plotted square
%       sfit - structured array containing the following fields
%           sfit.Center    - 3x1 center of the square
%           sfit.Rotation  - 3x3 rotation of the ellipsoid
%           sfit.Dimension - scalar containing dimension of square
%
%   Outputs:
%       h - patch object handle for the plotted square
%
%   See also plotRectanguloid
%
%   M. Kutzer, 31Jan2025, USNA

%% Check inputs
narginchk(1,2);

% Define parent
parentGiven = false;
nargin_i = 1;
if ishandle(varargin{nargin_i})
    switch get(varargin{nargin_i},'Type')
        case 'axes'
            parentGiven = true;
        case 'hgtransform'
            parentGiven = true;
    end
end

if parentGiven
    axs = varargin{nargin_i};
    nargin_i = nargin_i+1;
else
    axs = gca;
end

switch get(axs,'Type')
    case 'axes'
        hold(axs,'on');
end

% Define rectangle
if nargin >= nargin_i
	sfit = varargin{nargin_i};
end

%% Restructure
rfit.Center = sfit.Center;
rfit.Rotation = sfit.Rotation;
rfit.Dimensions = repmat(sfit.Dimension,1,2);

%% Plot square
h = plotRectangle(axs,rfit);