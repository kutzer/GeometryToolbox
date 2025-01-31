function h = plotCube(varargin)
% PLOTCUBE plots a cube in 3D
%   h = plotCube(rfit) plots a cube in the current axes
%
%   h = plotCube(axs,___)
%
%   Inputs:
%        axs - *optional* handle of the parent of the plotted cube
%       cfit - structured array containing the following fields
%           cfit.Center    - 3x1 center of the cube
%           cfit.Rotation  - 3x3 rotation of the ellipsoid
%           cfit.Dimension - scalar containing dimension of cube
%
%   Outputs:
%       h - patch object handle for the plotted cube
%
%   See also plotRectanguloid plotSquare plotRectangle
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
	cfit = varargin{nargin_i};
end

%% Restructure
rfit.Center = cfit.Center;
rfit.Rotation = cfit.Rotation;
rfit.Dimensions = repmat(cfit.Dimension,1,3);

%% Plot cube
h = plotRectanguloid(axs,rfit);