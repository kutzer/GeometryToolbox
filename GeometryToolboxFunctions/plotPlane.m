function p = plotPlane(varargin)
% PLOTPLANE visualizes a plane given a desired "center" and scale.
%   p = PLOTPLANE(axs,abcd,X,s)
%   p = PLOTPLANE(abcd,X,s)
%
%   Input(s)
%       axs  - parent of plane (optional, "gca" is used if no parent is
%              specified.
%       abcd - 1x4 array containing plane coefficients such that
%              (a*x + b*y + c*z + d = 0).
%       X    - 3x1 array "center point" used for visualizing the plane. If
%              the point is not on the plane, the point is projected onto 
%              the plane.
%       s    - scalar parameter defining scale around the center.
%   Output(s)
%       p - patch object of plane visualization
%
%   M. Kutzer, 27May2021, USNA

debugON = false;

%% Parse inputs
narginchk(1,4);

if numel(varargin{1}) == 1 && ishandle(varargin{1})
    axs = varargin{1};
    varargin(1) = [];
else
    axs = gca;
end

abcd = varargin{1};

% Set defaults
X_lim(1,:) = xlim(axs);
X_lim(2,:) = ylim(axs);
X_lim(3,:) = zlim(axs);
s = norm( diff(X_lim,1,2) )/2;
X = mean(X_lim,2);

if numel(varargin) > 1
    X = varargin{2};
end

if numel(varargin) > 2
    s = varargin{3};
end

%% Check inputs
if size(abcd,1) ~= 1 || size(abcd,2) ~= 4
    error('Plane must be defined using a 1x4 array.');
end

if size(X,1) ~= 3 || size(X,2) ~= 1
    error('"Center Point" must be defined using a 3x1 array.');
end

if numel(s) ~= 1
    error('Scaling must be defined as a scalar.');
end

%% Project X to the plane
X = proj2plane(abcd,X);

%% Define plane "frame"
z = abcd(1:3).';
z_hat = z./norm(z);
x_hat = orthogonalVector(z_hat);
y_hat = cross(z_hat,x_hat);

H_p2a = eye(4);
H_p2a(1:3,1:3) = [x_hat,y_hat,z_hat];
H_p2a(1:3,4) = X;

if debugON
    h_p2a = triad('Parent',axs,'Matrix',H_p2a,'Scale',s,'LineWidth',2,...
        'AxisLabels',{'x_p','y_p','z_p'});
end

%% Define corners of the plane in body-fixed coordinates
X_p = s*[...
    -1, 1, 1,-1;...
    -1,-1, 1, 1;...
     0, 0, 0, 0];
X_p(4,:) = 1;

%% Reference points to parent frame
X_a = H_p2a * X_p;
X_a(4,:) = [];

%% Visualize plane
p = patch('Faces',[1:4],'Vertices',X_a.','Parent',axs,'EdgeColor','none',...
    'FaceColor','b','FaceAlpha',0.5);
