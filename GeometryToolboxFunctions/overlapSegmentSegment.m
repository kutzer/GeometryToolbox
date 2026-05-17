function [s1,s2] = overlapSegmentSegment(seg1,seg2,ZERO)
% OVERLAPSEGMENTSEGMENT finds the parameter bounds for the overlap between
% two collinear segments.
%
%   Input(s)
%       seg1 - Nx2 coefficients of a parametric segment (see fitSegment)
%       seg2 - Nx2 coefficients of a parametric segment (see fitSegment)
%       ZERO - scalar value close to zero (default is 1e-8)
%
%   Output(s)
%       s1 - 1x2 array if the segments overlap and empty if not.
%       s2 - 1x2 array if the segments overlap and empty if not.
%
%   Notes: 
%   (1) For overlapping segments, s1 and s2 are defined as follows:
%       X1 = seg1*[s1; [1,1]] - Defines the end-points using seg1
%       X2 = seg2*[s2; [1,1]] - Defines the end-points using seg2
%   (2) If the overlap is a single point:
%       s1(1) = s1(2)
%       s2(1) = s2(2)
%
%   See also fitSegment isCollinearSegmentSegment
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

%% Set default output(s)
s1 = [];
s2 = [];

%% Check if segments are collinear
if ~isCollinearSegmentSegment(seg1,seg2,ZERO)
    return
end

%% Find segment end-points
X1 = seg1*[0,1; 1,1];
X2 = seg2*[0,1; 1,1];

%% Check for overlap
s1 = [...
    segmentX2s(seg1,X2(:,1),ZERO),...
    segmentX2s(seg1,X2(:,2),ZERO) ];

s2 = [...
    segmentX2s(seg2,X1(:,1),ZERO),...
    segmentX2s(seg2,X1(:,2),ZERO) ];

%% Account for round-off

% s1
tf0 = abs(s1) < ZERO;
tf1 = abs(s1 - 1) < ZERO;
s1(tf0) = 0;
s1(tf1) = 1;

% s2
tf0 = abs(s2) < ZERO;
tf1 = abs(s2 - 1) < ZERO;
s2(tf0) = 0;
s2(tf1) = 1;

%% Apply bounds

% s1
tfN = s1 < 0;
tfP = s1 > 1;
if all(tfN) || all(tfP)
    s1 = [];
    s2 = [];
    return
end
s1(tfN) = 0;
s1(tfP) = 1;

% s2
tfN = s2 < 0;
tfP = s2 > 1;
if all(tfN) || all(tfP)
    s1 = [];
    s2 = [];
    return
end
s2(tfN) = 0;
s2(tfP) = 1;

%% Generate unique result
s1 = unique(s1);
s2 = unique(s2);

%% Account for point overlap
if numel(s1) == 1
    s1 = repmat(s1,1,2);
end
if numel(s2) == 1
    s2 = repmat(s2,1,2);
end