function varargout = GeometryToolboxVer
% GEOMETRYTOOLBOXVER displays the Piecewise Polynomial Toolbox information.
%   GEOMETRYTOOLBOXVER displays the information to the command prompt.
%
%   A = GEOMETRYTOOLBOXVER returns in A the sorted struct array of  
%   version information for the Piecewise Polynomial Toolbox.
%     The definition of struct A is:
%             A.Name      : toolbox name
%             A.Version   : toolbox version number
%             A.Release   : toolbox release string
%             A.Date      : toolbox release date
%
%   M. Kutzer 28Aug2018, USNA

% Updates
%   21Apr2021 - Migrated patchSphere from Geometry Toolbox to Patch Toolbox
%   16Sep2021 - Created interpCircle
%   09Feb2022 - Updated firArc to better select shortest arc length
%               solution
%   24Feb2022 - Updated fitPlane to orient plane
%   07Mar2022 - Added plotSphere
%   17Mar2022 - Corrected parent assignment issue in plotShere
%   06Jan2023 - Corrected varargin issue with distSegmentSegment
%   05Mar2023 - Added fitArc2pntRad
%   05Sep2024 - Migrated fitCirclePTT and associated functions to toolbox
%   31Jan2025 - Added rectangle, square, rectanguloid, cube plot functions

A.Name = 'Geometry Toolbox';
A.Version = '1.1.3';
A.Release = '(R2022a)';
A.Date = '31-Jan-2025';
A.URLVer = 1;

msg{1} = sprintf('MATLAB %s Version: %s %s',A.Name, A.Version, A.Release);
msg{2} = sprintf('Release Date: %s',A.Date);

n = 0;
for i = 1:numel(msg)
    n = max( [n,numel(msg{i})] );
end

fprintf('%s\n',repmat('-',1,n));
for i = 1:numel(msg)
    fprintf('%s\n',msg{i});
end
fprintf('%s\n',repmat('-',1,n));

if nargout == 1
    varargout{1} = A;
end