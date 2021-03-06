function h = plotArc(varargin)
% PLOTARC plots one or more arcs defined in 3D.
%   h = PLOTARC(afit) plots one or more arcs sharing the same center and 
%   body-fixed frame orientation with a default of 100 equally spaced 
%   points on each arc.
%
%   h = PLOTARC(afit,N) plots one or more arcs with a user-specified number
%   of points. 
%
%   h = PLOTARC(axs,___) allows the user to specify the parent of the plot
%   object(s).
%
%   Inputs:
%        axs - *optional* handle of the parent of the plotted arc
%       afit - structured array containing the following fields
%           afit.Center    - 3x1 center of the arc
%           afit.Rotation  - 3x3 orientation of the arc (rotation is 
%                              about the z-direction)
%           afit.Radius    - radius of the arc
%           afit.AngleLims - Nx2 array containing the bounds of the 
%                            angles used to define the arc.
%                AngleLims(i,:) - lower and upper bounds of the angle
%                                 defining the ith arc intersection. 
%          N - *optional* number of points used to plot the arc
%
%   Outputs:
%       h - line object handle(s) for each of the angle limit pairs 
%           contained in afit
%
%   M. Kutzer, 23Jun2020, USNA

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

% Define arc
if nargin >= nargin_i
	afit = varargin{nargin_i};
    nargin_i = nargin_i+1;
end

% Define number of points
% TODO - consider updating N to allow a user to specify the number of
% points on the entire circle? Having 100 points between two close angles
% is a waste of memory. 
if nargin >= nargin_i
    N = varargin{nargin_i};
else
    N = 100;
end

%% Check for empty afit
if isempty(afit)
    h = [];
    return
end

%% Define circle frame
H_c2w = eye(4);
H_c2w(1:3,1:3) = afit.Rotation;
H_c2w(1:3,4) = afit.Center;

%% Define arcs
for i = 1:size(afit.AngleLims,1)
    theta = linspace(afit.AngleLims(i,1),afit.AngleLims(i,2),N);
    
    % Define body-fixed points
    X_c(1,:) = afit.Radius.*cos(theta);
    X_c(2,:) = afit.Radius.*sin(theta);
    X_c(3,:) = 0;
    X_c(4,:) = 1;
    
    % Define world-referenced points
    X_w = H_c2w*X_c;
    
    % Plot arc
    h(i) = plot3(X_w(1,:),X_w(2,:),X_w(3,:),'Parent',axs,'Color','b','LineWidth',2);
end
