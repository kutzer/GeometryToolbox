function varargout = proj2plane(pln,X)
% PROJ2PLANE projects a set of points to a specified plane
%   Xproj = PROJ2PLANE(pln,X) projects the N points contained in the 3xN
%   array X to the plane specified as either a 1x4 array or a planeModel
%   object. 
%
%       X   - 3xN array containing points
%       pln - 1x4 array containing coefficients for plane equation 
%           [a,b,c,d] such that a*x + b*y + c*z + d = 0 *or* a valid
%           planeModel object
%
%   [..., meanError] = PROJ2PLANE(...) additionally returns the mean 
%   error of the Euclidean distance between the provided points and 
%   their corresponding projections.
%
%   [..., Error] = PROJ2PLANE(...) additionally returns errors for each
%   projected point.
%
%   References
%       [1] http://mathworld.wolfram.com/Point-PlaneDistance.html
%
%   See also fitplane, pcfitplane, planeModel
%
%   M. Kutzer, 20Dec2017, USNA

%% Check Inputs
narginchk(2,2);

% Get plane normal
switch lower( class(pln) )
    case 'planemodel'
        n = transpose( pln.Normal );
        d = pln.Parameters(4);
    case 'double'
        n = transpose( pln(1:3) );
        d = pln(4);
    case 'single'
        n = transpose( pln(1:3) );
        d = pln(4);
    case 'sym'
        n = transpose( pln(1:3) );
        d = pln(4);
    otherwise
        error('Plane must be specified as a 1x4 array or a valid planeModel object.');
end

% Check points
[M,~] = size(X);
if M ~= 3
    error('Specified points must be provided as a 3xN array.');
end

%% Define Hessian normal form of plane
n_hat = n./norm(n);
p = d./norm(n);

[M,~] = size(n_hat);
if M ~= 3
    error('Unit normal must be specified as a 3x1 vector.');
end

%% Define distances
D = transpose(n_hat)*X + p;

%% Define projections
Xproj = X - D.*n_hat;

%% Package outputs
if nargout > 0
    varargout{1} = Xproj;
end

if nargout > 1
    meanError = mean(D);
    varargout{2} = meanError;
end

if nargout > 2
    varargout{3} = D;
end