function [s,tfOnSegment,tfOnLine] = segmentX2s(seg,X,ZERO)
% SEGMENTX2S recovers the parameterization value given segment coefficients
% and a point.
%   s = segmentX2s(seg,X)
%   s = segmentX2s(seg,X,ZERO)
%   [s,tfOnSegment,tfOnLine] = segmentX2s(___)
%
%   Input(s)
%       seg - 2x2 array specifying the coefficients "C" associated with a 
%             2D segment such that X = C*[s; 1].
%         X - 2x1 array specifying the point for the recovered
%             parameterization. If the point does not lie on the segment,
%             an empty set is returned.
%      ZERO - [OPTIONAL] specifies a positive value near zero to use for
%             comparison of recovered values. If unspecified, ZERO = 1e-8.
%
%   Output(s)
%         s - scalar value specifying the value of s associated with the
%             specified point. If the point does not lie on the line
%             containing the segment, and empty set is returned.
%       tfOnSegment - binary (true/false) value indicating whether the
%                     specified point lies on the segment.
%          tfOnLine - binary (true/false) value indicating whether the
%                     specified point lies on the line containing the 
%                     segment.
%
%   See also fitSegment
%
%   M. Kutzer, 10May2024, USNA

%% Check input(s)
narginchk(2,3);

if ~ismatrix(seg) || ~isnumeric(seg) || size(seg,1) ~= size(seg,2) || size(seg,1) ~= 2
    error('Segment coefficients must be defined as a 2x2 array.');
end

if ~isnumeric(X) || numel(X) ~= 2
    error('Specified point must be a 2x1 array.');
end

if nargin < 3
    ZERO = 1e-8;
end

if ~isnumeric(ZERO) || numel(ZERO) ~= 1 || ZERO < 0
    error('ZERO must be specified as a scalar positive value.');
end

%% Recover values of s for x and y
M = seg(:,1);
P = seg(:,2);

% Account for special cases:
%   (1) M(1) ~= 0 [VERTICAL LINE]
%   (2) M(2) ~= 0 [HORIZONTAL LINE]
if abs(M(1)) <= ZERO
    % (1) M(1) ~= 0 [VERTICAL LINE]
    if abs(X(1) - P(1)) <= ZERO
        s(1:2,1) = (X(2) - P(2))./M(2);
    else
        s = [];
        tfOnSegment = false;
        tfOnLine = false;
        return
    end
elseif abs(M(2)) <= ZERO
    % (2) M(2) ~= 0 [HORIZONTAL LINE]
    if abs(X(2) - P(2)) <= ZERO
        s(1:2,1) = (X(1) - P(1))./M(1);
    else
        s = [];
        tfOnSegment = false;
        tfOnLine = false;
        return
    end
else
    % Standard case
    s = (X - P)./M; % 2x1 array
end

%fprintf('\ts1 = %.4f, s2 = %.4f\n',s);

%% Initialize binary outputs
tfOnSegment = false;
tfOnLine = false;

%% Check if values of s are "the same" (i.e. point lies on line)
if abs( diff(s) ) < ZERO
    % Values are "the same"
    tfOnLine = true;
else
    % Values are not the same, assume no intersection has occurred
    %fprintf('\ts1 = %.4f, s2 = %.4f -> ?No Intersect?\n',s);
    s = [];
    return
end

s = mean(s);

%% Check if s \in [0,1] (i.e. on the segment)
s0 = 0;
s1 = 1;

if s >= s0 && s0 <= s1
    tfOnSegment = true;
end

% Account for "very close" condition
if abs(s-s0) < ZERO
    tfOnSegment = true;
end

if abs(s-s1) < ZERO
    tfOnSegment = true;
end
end