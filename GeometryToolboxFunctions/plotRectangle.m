function h = plotRectangle(varargin)
% PLOTRECTANGLE plots a rectangle in 3D
%   h = plotRectangle(rfit) plots a rectangle in the current axes
%
%   h = plotRectangle(axs,___)
%
%   Inputs:
%        axs - *optional* handle of the parent of the plotted rectangle
%       rfit - structured array containing the following fields
%           rfit.Center     - 3x1 center of the rectangle
%           rfit.Rotation   - 3x3 rotation of the ellipsoid
%           rfit.Dimensions - 1x2 array containing length and width
%                             dimensions
%
%   Outputs:
%       h - patch object handle for the plotted rectangle
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
	rfit = varargin{nargin_i};
end

%% Define rectangle points
% Define N
N = 4;

% Isolate dimensions
d = reshape(rfit.Dimensions,[],1);

% Define x/y coordinates
X_b = repmat(d./2,1,N).*[...
    -1,+1,+1,-1;...
    -1,-1,+1,+1];
% Append 0 z-coordinate
X_b(3,:) = 0;
% Make homogeneous
X_b(4,:) = 1;

%% Transform points
R_b2w = rfit.Rotation;
d_b2w = reshape(rfit.Center,[],1);
H_b2w = [R_b2w, d_b2w; [0,0,0,1]];

X_w = H_b2w * X_b;

%% Define patch object(s)
rec.Vertices = X_w(1:3,:).';
rec.Faces = 1:N;
h = patch(rec,'FaceColor','None','EdgeColor','b','LineWidth',2,'Parent',axs);
