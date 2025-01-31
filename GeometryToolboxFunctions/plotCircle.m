function h = plotCircle(varargin)
% PLOTCIRCLE plots a circle defined in 3D.
%   h = PLOTCIRCLE(cfit) plots a circle with a default of 100 equally
%   spaced points.
%
%   h = PLOTCIRCLE(cfit,N) plots a circle with a user-specified number of
%   points.
%
%   h = PLOTCIRCLE(axs,___) allows the user to specify the parent of the
%   plot object.
%
%   Inputs:
%        axs - *optional* handle of the parent of the plotted circle
%       cfit - structured array containing the following fields
%           cfit.Center - 3x1 center of the circle
%           cfit.Normal - 3x1 normal to the circle
%           cfit.Radius - radius of the circle
%          N - *optional* number of points used to plot the circle
%
%   Outputs:
%       h - patch object handle for the plotted circle
%
%   See also fitCircle interpCircle
%
%   M. Kutzer, 20Jun2020, USNA

% Updates
%   16Sep2021 - Added See also and isolated interpCirle function

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
	cfit = varargin{nargin_i};
    nargin_i = nargin_i+1;
end

% Define number of points
if nargin >= nargin_i
    N = varargin{nargin_i};
else
    N = 100;
end

%% Check parameters
% TODO - check parameters

%% Interpolate points on circle
X_w = interpCircle(cfit,N);

%% Patch result
%h = plot3(X_w(1,:),X_w(2,:),X_w(3,:),'Parent',axs,'LineWidth',2);
c.Vertices = X_w(1:3,:).';
c.Faces = 1:N;
h = patch(c,'FaceColor','None','EdgeColor','b','LineWidth',2,'Parent',axs);