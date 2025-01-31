function h = plotCylinder(varargin)
% PLOTCYLINDER plots a cylinder defined in 3D
%   h = plotCylinder(cyfit) plots a cylinder with a default of 100 equally
%   spaced points about the circular faces
%
%   h = plotCylinder(cyfit,N) plots a cylinder with a user-specified number
%   of points.
%
%   h = plotCylinder(axs,___)
%
%   Inputs:
%        axs - *optional* handle of the parent of the plotted cylinder
%       cfit - structured array containing the following fields
%           cyfit.Center - 3x1 center of the cylinder
%           cyfit.Normal - 3x1 normal to the cylinder
%           cyfit.Height - radius of the cylinder
%           cyfit.Radius - radius of the cylinder
%          N - *optional* number of points used to plot the cylinder
%
%   Outputs:
%       h - patch object handle for the plotted cylinder
%
%   See also fitCircle interpCircle
%
%   M. Kutzer, 31Jan2025, USNA

%% Check inputs
narginchk(1,3);

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

% Define circle
if nargin >= nargin_i
	cyfit = varargin{nargin_i};
    nargin_i = nargin_i+1;
end

% Define number of points
if nargin >= nargin_i
    N = varargin{nargin_i};
else
    N = 100;
end

%% Parse parameters
n_hat = reshape( cyfit.Normal./norm(cyfit.Normal), [], 1 );
r = cyfit.Radius;
h = cyfit.Height;

%% Define circular faces
% Define circle fit
cfit = cyfit;
cfit = rmfield(cfit,'Height');

% Define interpolated points
X_w0 = interpCircle(cfit,N);

% Define lower and upper faces
X_wL = X_w0 + repmat(n_hat,1,N).*(-h/2);
X_wU = X_w0 + repmat(n_hat,1,N).*( h/2);

%% Define patch object(s)
cy.Vertices = [X_wL(1:3,:), X_wU(1:3,:)].';
cy.Faces = [...
    (1:N)+0;... % Lower face
    (1:N)+N];   % Upper face

for i = 1:N
    if i < N
        face = [[1,2]+(i-1), [2,1]+(i-1)+N];
    else
        face = [[N,1],[N+1,2*N]];
    end
    cy.Faces(end+1,:) = nan;
    cy.Faces(end,1:4) = face;
end

h = patch(cy,'FaceColor','b','FaceAlpha',0.5,...
    'EdgeColor','none','LineWidth',2);