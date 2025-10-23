function [tf,s] = isIntersectPointSegment(X,seg,ZERO)
% ISINTERSECTPOINTSEGMENT defines whether or not a point intersects with a
% specific segment.
%   [tf,s] = isIntersectPointSegment(X,seg,ZERO)
%
%   Input(s)
%       X - 2x1 array defining the point
%       seg - 2x2 array defining the segment coefficients
%       ZERO - [OPTIONAL] scalar defining approximate zero
%
%   Output(s)
%       tf - logical scalar defining whether or not the point intersects
%            the segment
%       s - scalar defining the place on the segment where the intersection
%           occurs
%
%   See also fitSegment
%
%   M. Kutzer, 23Oct2025, USNA

%% Check input(s)
% TODO - check inputs

if nargin < 3
    ZERO = 1e-8;
end

%% Find intersection
% Isolate first and second columns of segment coefficients
A1 = seg(:,1);
A2 = seg(:,2);

n = numel(A1);
s = nan(1,n);
for i = 1:n
    s(i) = (X(i)-A2(i))/A1(i);
end

%% Define whether or not the point is on the segment
if abs( diff(s) ) < ZERO
    tf = true;
    s = mean(s);
else
    tf = false;
    s = [];
end