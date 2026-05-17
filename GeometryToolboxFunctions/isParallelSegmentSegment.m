function tf = isParallelSegmentSegment(seg1,seg2,ZERO)
% ISPARALLELSEGMENTSEGMENT checks if two segments are parallel
%   tf = isParallelSegmentSegment(seg1,seg2,ZERO)
%
%   Input(s)
%       seg1 - Nx2 coefficients of a parametric segment (see fitSegment)
%       seg2 - Nx2 coefficients of a parametric segment (see fitSegment)
%       ZERO - scalar value close to zero (default is 1e-8)
%
%   Output(s)
%       tf - scalar logical value indicating whether or not segments are
%            parallel
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
tf = norm( cross(seg1(:,1),seg1(:,2)) ) < ZERO;