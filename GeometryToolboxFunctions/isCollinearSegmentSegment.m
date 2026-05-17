function tf = isCollinearSegmentSegment(seg1,seg2,ZERO)
% ISCOLLINEARSEGMENTSEGMENT checks if two segments are collinear
%   tf = isCollinearSegmentSegment(seg1,seg2,ZERO)
%
%   Input(s)
%       seg1 - Nx2 coefficients of a parametric segment (see fitSegment)
%       seg2 - Nx2 coefficients of a parametric segment (see fitSegment)
%       ZERO - scalar value close to zero (default is 1e-8)
%
%   Output(s)
%       tf - scalar logical value indicating whether or not segments are
%            collinear
%
%   See also fitSegment isParallelSegmentSegment
%
%   M. Kutzer, 17May2026, USNA

%% Check input(s)
narginchk(2,3);

if nargin < 3
    ZERO = 1e-8;
end

if size(seg1,2) ~= 2
    error('First segment must be defined as an Nx2.');
end
if size(seg2,2) ~= 2
    error('Second segment must be defined as an Nx2.');
end
if size(seg1,1) ~= size(seg2,1)
    error('First and second segments must be defined in the same dimensional space.');
end

%% Check for parallel segments
tf = isParallelSegmentSegment(seg1,seg2,ZERO);

if ~tf
    return
end

%% Check if segments are collinear
v1 = seg1(:,1);
%v2 = seg2(:,1);

v1_hat = v1./norm(v1);
%v2_hat = v2./norm(v2);

p1 = seg1(:,2);
p2 = seg2(:,2);

% Check for shared end-point
if norm(p2-p1) < ZERO
    % Choose another end-point
    p2 = seg2*[1;1];

    % Check if second end-point is shared
    if norm(p2-p1) < ZERO
        p2 = seg2*[0.5;1];
    end
end

p12_hat = (p2-p1)./norm(p2-p1);

dotProd = dot(v1_hat,p12_hat);

tf = abs(1 - abs(dotProd)) < ZERO;