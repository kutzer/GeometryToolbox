function [d_mag,d,d1,d2] = distSegmentSegment(varargin)
% DISTSEGMENTSEGMENT calculates the distance between two segments defined
% by end-points.
%   d = DISTSEGMENTSEGMENT(seg(1),seg(2)) calculates the distance between two
%   segments defined in seg(1) and seg(2) respectively. The function inputs must be
%   defined as structured arrays with fields "Point0" and "Point1" where
%   s_.Point_ is an N-element array where N = 2 or N = 3.
%
%   d = DISTSEGMENTSEGMENT(p1,p2,p3,p4) calculates the distance between two
%   segments with endpoints [p1, p2] and [p3, p4]. The function inputs must
%   be defined as N-element arrays where N = 2 or N = 3.
%
%   [d_mag,d,d1,d2] = DISTSEGMENTSEGMENT(___) returns the distance between
%   segments (d_mag), the vector connecting the two closest points (d), and
%   the points associated with the shortest distance (d1 and d2).
%
%   References:
%       [1] D. Sunday, "The 3D minimum distance between 2 segments, 
%           dist3D_Segment_to_Segment()," 
%           http://geomalgorithms.com/a07-_distance.html, Accessed 
%           06Nov2018.
%
%   M. Kutzer, 06Nov2018, USNA

% TODO - add ZERO as an input to this function!!!

% Update(s)
%   06Jan2023 - Revised varargin parsing for nargin == 2
%   17May2026 - Revised to check for parallel and co-linear segments
%   17May2026 - Revised to check for intersecting segments

% TODO - This function can be expanded to work with Nth order lines (i.e.
% remove the N = 2 or N = 3 constraint.

%% Parse inputs
seg = [];

% Parse inputs for two input arguments
if nargin == 2
    % Check fields
    fieldsCheck = {'Point0','Point1'};
    nFields = numel(fieldsCheck);
    for i = 1:nargin
        if nnz( isfield(varargin{i},fieldsCheck) ) ~= nFields || numel( fields(varargin{i}) ) ~= nFields
            error('distSegmentSegment(s1,s2) requires s1 and s2 to be defined segment structures with fields "Point0" and "Point1".');
        end
    end
    
    % Force end-points to be Nx1
    seg.Point0 = reshape(varargin{1}.Point0,[],1);
    seg.Point1 = reshape(varargin{1}.Point1,[],1);
    seg(2).Point0 = reshape(varargin{2}.Point0,[],1);
    seg(2).Point1 = reshape(varargin{2}.Point1,[],1);
end

% Parse inputs for four input arguments
if nargin == 4
    % TODO - consider adding an Nx1 or 1xN check
    seg.Point0 = reshape(varargin{1},[],1); % Segment 1 start point
    seg.Point1 = reshape(varargin{2},[],1); % Segment 1 end point)
    seg(2).Point0 = reshape(varargin{3},[],1); % Segment 2 start point
    seg(2).Point1 = reshape(varargin{4},[],1); % Segment 2 end point
end

if isempty(seg)
    error('Incorrect number of input arguments.');
end

% Check number of elements
for i = 1:2
    for j = 0:1
        fieldName = sprintf('Point%d',j);
        eFLAG = false;
        % Check points in segment 1
        if numel(seg(i).(fieldName)) > 3 || numel(seg(i).(fieldName)) < 2
            eFLAG = true;
        end

        % Throw 2 input error
        if eFLAG && nargin == 2
            error('distSegmentSegment(seg(1),seg(2)) requires the "Point0" and "Point1" fields to be defined as N-element arrays where N = 2 or N = 3.');
        end
        % Throw 4 input error
        if eFLAG && nargin == 4
            error('distSegmentSegment(p1,p2,p3,p4) requires p1, p2, p3 and p4 to be defined as N-element arrays where N = 2 or N = 3.');
        end
        % Append zero if necessary
        if numel(seg(i).(fieldName)) < 3
            seg(i).(fieldName)(3) = 0;
        end
    end
end

%% Check for the existance of zeroFPError
switch exist('zeroFPError','file')
    case 2
        % At least one file from the toolbox is installed!
    otherwise
        fprintf(2,'Please install the ScorBot toolbox before running this code.\n\n');
        web('https://www.usna.edu/Users/weapsys/kutzer/_Code-Development/ScorBot_Toolbox.php','-browser');
        return
end

%% Consider the special case(s)
% -> Segments are co-linear
ZERO = 1e-8; % TODO - add ZERO as an input to this function!!!
for i = 1:numel(seg)
    segX{i} = [seg(i).Point0,seg(i).Point1];
    segCoef{i} = fitSegment(seg(i).Point0,seg(i).Point1);
end

% Check if segments are parallel
tfParallel = norm( cross(segCoef{1}(:,1),segCoef{2}(:,2)) ) < ZERO;
if tfParallel
    % Segments are parallel

    % Check if segments are colinear
    v_between = segCoef{2}(:,2) - segCoef{1}(:,1);
    tfColinear = norm( cross(segCoef{1}(:,1),v_between) ) < ZERO;
    if tfColinear
        % Segments are co-linear

        s1 = [...
            segmentX2s(segCoef{1},segX{2}(:,1),ZERO),...
            segmentX2s(segCoef{1},segX{2}(:,2),ZERO) ];

        s2 = [...
            segmentX2s(segCoef{2},segX{1}(:,1),ZERO),...
            segmentX2s(segCoef{2},segX{1}(:,2),ZERO) ];
        
        % Check if segments overlap
        if any(s1 > -ZERO & s1-1 < ZERO) && any(s2 > -ZERO & s2-1 < ZERO)
            % Segments overlap!
            s1 = mean( s1( s1 > -ZERO & s1-1 < ZERO) );
            s2 = mean( s2( s2 > -ZERO & s2-1 < ZERO) );

            d_mag = 0;

            d1 = segCoef{1}*[s1; 1];
            d2 = segCoef{2}*[s2; 1];

            d = d2 - d1;
        else
            % Segments do not overlap
            % -> Find closest end-points
            d = inf(size(segX{1},2),size(segX{2},2));
            for i = 1:size(segX{1},2)
                for j = 1:size(segX{2},2)
                    d(i,j) = norm( segX{2}(:,j) - segX{1}(:,i) );
                end
            end
            [i,j] = find(d == min(reshape(d,1,[])),1,'first');

            d1 = segX{1}(:,i);
            d2 = segX{2}(:,j);

            d = d2 - d1;

            d_mag = norm(d);
        end

        return
    end
end

% -> Segments intersect
[intEE,intEV,intVV,intPt] = intersectSegmentSegment(segX{1},segX{2},ZERO);
if intEE || intEV || intVV
    d_mag = 0;

    d1 = intPt;
    d2 = intPt;

    d = d2 - d1;
    return
end

%% Calculate shortest distance
% This code is based off of the code posted to [1]. Per the distribution
% instructions of [1], the following copyright information is included:
%
% Copyright 2001 softSurfer, 2012 Dan Sunday
%   This code may be freely used, distributed and modified for any purpose
%   providing that this copyright notice is included with it.
%   SoftSurfer makes no warranty for this code, and cannot be held
%   liable for any real or imagined damage resulting from its use.
%   Users of this code must verify correctness for their application.

%% Calculate vectors and initialize values
u = seg(1).Point0 - seg(1).Point1; % Vector pointing from Point1 to Point0, segment 1
v = seg(2).Point0 - seg(2).Point1; % Vector pointing from Point1 to Point0, segment 2
w = seg(1).Point1 - seg(2).Point1; % Vector pointing from segment 2 Point1 to segment 1 Point1

a = dot(u,u);   % Squared norm of u (a >= 0)
b = dot(u,v);
c = dot(v,v);   % Squared norm of v (c >= 0)
d = dot(u,w);
e = dot(v,w);
D = a*c - b*b;  % a*c >= b*b thus D >= 0 
sD = D;         % sc = sN/sD, default sD = D >= 0
tD = D;         % sc = sN/sD, default sD = D >= 0

%% Compute the line parameters of the two closest points
if zeroFPError(D) == 0
    % D = 0 indicates that the lines are almost parallel
    sN = 0.0; % Force intersect at Point0 on segment 1 
    sD = 1.0; % Prevent possible divide by 0.0 later?
    tN = e;
    tD = c;
else
    % Get the closest points on the infinite lines
    sN = (b*e - c*d);
    tN = (a*e - b*d);
    % Check end points?
    if sN < 0
        % The s=0 edge is visible (sc < 0)?
        sN = 0;
        tN = e;
        tD = c;
    elseif sN > sD
        % The s=1 edge is visible (sc > 1)?
        sN = sD;
        tN = e + b;
        tD = c;
    end
end

%% Check if t = 0 edge is visible or if t = 1 edge is visible
if tN < 0
    % tc < 0 indicates that the t=0 edge is visible
    tN = 0;
    % Recompute sc for this edge
    if (-d < 0)
        sN = 0;
    elseif (-d > a)
        sN = sD;
    else
        sN = -d;
        sD = a;
    end
elseif (tN > tD)
    % tc > 1 indicates that the t=1 edge is visible
    tN = tD;
    % Recompute sc for this edge
    if ((-d + b) < 0)
        sN = 0;
    elseif ((-d + b) > a)
        sN = sD;
    else
        sN = (-d + b);
        sD = a;
    end
end

%% Do the division to get sc and tc
if zeroFPError(sN) == 0
    sc = 0;
else
    sc = sN/sD;
end

if zeroFPError(tN) == 0
    tc = 0;
else
    tc = tN/tD;
end

%% Get the distance and package the outputs
d = w + (sc * u) - (tc * v);   % Vector pointing from closest point on 
                               % segment 1 to closest point on segment 2
% Calculate distance
d_mag = norm(d);

% Calculate closest points if number of outputs is specified
if nargout > 1
    d1 = seg(1).Point1 + sc*u;   % Closest point on segment 1
end
if nargout > 2
	d2 = seg(2).Point1 + tc*v;   % Closest point on segment 2
end
end