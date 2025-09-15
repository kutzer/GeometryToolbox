function varargout = plotEllipsoid(varargin)
% PLOTELLIPSOID creates a patch object of an ellipsoid.
%   p = PLOTELLIPSOID(efit) creates a patch object of an ellipsoid.
%
%       efit - structured array containing the following fields
%           efit.Center         - 3x1 center of the ellipsoid
%           efit.Rotation       - 3x3 rotation of the ellipsoid
%           efit.PrincipalRadii - radii of each principal semi-axis
%
%   [p,h] = PLOTELLIPSOID(efit) creates a patch object of an ellipsoid
%   defined about its origin and translates/rotates the ellipsoid using an
%   hgtransform object.
%
%   [...] = PLOTELLIPSOID(axs,...) specifies the axes or parent containing
%   the ellipsoid.
%
%   [...] = PLOTELLIPSOID(...,N) creates a patch object with N^2 faces
%   (default N = 50).
%
%   See also makeEllipsoid, fitEllipsoid, inEllipsoid, proj2ellipsoid
%
%   M. Kutzer, 03Jan2018, USNA

% Updates
%   19Jan2022 - Corrected narginchk error
%   08Mar2022 - Check for 3-element principal radii
%   15Sep2025 - Updated ancestor call to includes 'axes'

%% Check inputs
narginchk(1,3);

% Parse inputs
N = 50;
if nargin == 1
    axs = gca;
    efit = varargin{1};
end
if nargin == 2
    if ishandle(varargin{1})
        axs = varargin{1};
        efit = varargin{2};
    else
        axs = gca;
        efit = varargin{1};
        N = varargin{2};
    end
end
if nargin == 3
    axs = varargin{1};
    efit = varargin{2};
    N = varargin{3};
end

% Check efit
flds = {'Center','Rotation','PrincipalRadii'};
if ~(sum( isfield(efit,flds) ) == numel(flds))
    msg = 'Ellipsoid must be specified by a structured array containing the following fields: ';
    for i = 1:numel(flds)
        if i < numel(flds)
            msg = sprintf('%s%s, ',msg,flds{i});
        else
            msg = sprintf('%sand %s.',msg,flds{i});
        end
    end
    error(msg);
end

% Deconflict axs/hgtransform
h_e2a = axs;
axs = ancestor(h_e2a,'axes');

%% Plot ellipsoid
r = efit.PrincipalRadii;

% Check for valid principal radii
if numel(r) ~= 3
    error('Principal Radii must be specifed as a 3-element array.');
end

[x,y,z] = ellipsoid(0,0,0,r(1),r(2),r(3),N);
[m,n] = size(x);

X = [reshape(x,1,[]); reshape(y,1,[]); reshape(z,1,[])];
X(4,:) = 1;

H = eye(4);
H(1:3,1:3) = efit.Rotation;
H(1:3,4) = efit.Center;

if nargout < 2
    X = H*X;
    x = reshape(X(1,:),m,n);
    y = reshape(X(2,:),m,n);
    z = reshape(X(3,:),m,n);
    
    srf = surf(axs,x,y,z,'Visible','off');
    ptc = surf2patch(srf);
    delete(srf);
    p = patch(axs,ptc,'EdgeColor','None','FaceColor','b','FaceAlpha',0.5);
    if nargout == 1
        varargout{1} = p;
    end
else
    srf = surf(axs,x,y,z,'Visible','off');
    ptc = surf2patch(srf);
    delete(srf);
    p = patch(axs,ptc,'EdgeColor','None','FaceColor','b','FaceAlpha',0.5);
    % TODO - Something is wrong with the MATRIX PROPERTY HERE. It may be an
    %        issue with TRIAD.
    h = triad('Parent',h_e2a,'Scale',min( abs(r) ),'LineWidth',1.5,'Matrix',H);
    set(p,'Parent',h);
    varargout{1} = p;
    varargout{2} = h;
end