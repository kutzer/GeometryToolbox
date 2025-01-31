function h = plotRectanguloid(varargin)
% PLOTRECTANGULOID plots a 3D rectanguloid
%   h = plotRectangle(rfit) plots a rectanguloid in the current axes
%
%   h = plotRectangle(axs,___)
%
%   Inputs:
%        axs - *optional* handle of the parent of the plotted rectanguloid
%       rfit - structured array containing the following fields
%           rfit.Center     - 3x1 center of the rectanguloid
%           rfit.Rotation   - 3x3 rotation of the ellipsoid
%           rfit.Dimensions - 1x3 array containing length, width, and
%                             height dimensions
%
%   Outputs:
%       h - patch object handle for the plotted rectanguloid
%
%   See also plotRectangle plotSquare plotCube
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

% Define rectanguloid
if nargin >= nargin_i
	rfit = varargin{nargin_i};
end

%% Define rectangle points
% Define N
N = 4;

% Isolate dimensions
d = reshape(rfit.Dimensions,[],1);

% Define x/y coordinates
X_b0 = repmat(d(1:2,:)./2,1,N).*[...
    -1,+1,+1,-1;...
    -1,-1,+1,+1];
% Append 0 z-coordinate
X_b0(3,:) = 0;
% Make homogeneous
X_b0(4,:) = 1;

% Define lower and upper faces
X_bL = X_b0 + repmat([0;0;1;0],1,N).*(-d(3)/2);
X_bU = X_b0 + repmat([0;0;1;0],1,N).*( d(3)/2);

%% Transform points
R_b2w = rfit.Rotation;
d_b2w = reshape(rfit.Center,[],1);
H_b2w = [R_b2w, d_b2w; [0,0,0,1]];

X_wL = H_b2w * X_bL;
X_wU = H_b2w * X_bU;

% Isolate x/y/z
X_wL(4,:) = [];
X_wU(4,:) = [];

%% Define patch object(s)
r.Vertices = [X_wL(1:3,:), X_wU(1:3,:)].';
r.Faces = [...
    (1:N)+0;... % Lower face
    (1:N)+N];   % Upper face

for i = 1:N
    if i < N
        face = [[1,2]+(i-1), [2,1]+(i-1)+N];
    else
        face = [[N,1],[N+1,2*N]];
    end
    r.Faces(end+1,1:4) = face;
end

h = patch(r,'FaceColor','b','FaceAlpha',0.5,...
    'EdgeColor','b','LineWidth',2,'Parent',axs);
