%% TEST_tfIntersectPointSegment

%% Define random segment
seg = rand(2,2);

fig = figure;
axs = axes('Parent',fig,'NextPlot','add');
plt = plotSegment(axs,seg);

%% Define random point
%X = rand(2,1);
X = seg*[rand(1); 1];

pltX = plot(axs,X(1),X(2),'*m');

%% Calculate intersect
[tf,s] = isIntersectPointSegment(X,seg);
if tf
    set(pltX,'Color','g');
else
    set(pltX,'Color','r');
end