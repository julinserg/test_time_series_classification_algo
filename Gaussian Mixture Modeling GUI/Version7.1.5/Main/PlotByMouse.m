function patterns = PlotByMouse(DrawingMode,N)
% Left button click = draw    (but = 1)
% Right buttn click = jump a line spot (but=3)
% Return = Finish

patterns = [];
cla reset;
axis([0 1 0 1])
but          = 1;
LinesCoords  = [];
RandSamps    = normrnd(0,0.1,N,2);
TheOnes      = ones(N, 1);
while but < 4
    [x,y,but] = ginput(1);
    LinesCoords = [LinesCoords; x y];
    if but == 1
        if size(LinesCoords,1) > 1
            hold on
            if strcmp(DrawingMode, 'Lines') && but==1
                plot([LinesCoords(end,1) LinesCoords(end-1,1)],...
                    [LinesCoords(end,2) LinesCoords(end-1,2)],'k');
            elseif strcmp(DrawingMode, 'Gaussians')
                q1 = LinesCoords(end,1)-LinesCoords(end-1,1);
                q2 = LinesCoords(end,2)-LinesCoords(end-1,2);
                var1 = abs(q1);
                var2 = abs(q2);
                v12  = sign(q1*q2)*abs(q1)*abs(q2);
                SigmaMat = [var1 v12;v12 var2];
                mu1 = (LinesCoords(end,1)+LinesCoords(end-1,1))/2;
                mu2 = (LinesCoords(end,2)+LinesCoords(end-1,2))/2;
                PatternsPerG=RandSamps*(SigmaMat) +[mu1*TheOnes ...
                                                    mu2*TheOnes];
                plot(PatternsPerG(:,1), PatternsPerG(:,2),'k.');
                patterns = [patterns; PatternsPerG];
            end
            drawnow
        end
    end
end

if strcmp(DrawingMode, 'Lines')
    set(gca,'XColor','w','YColor','w');
    f=getframe(gca);
    set(gca,'XColor','k','YColor','k');
    axis([0 1 0 1]);
    BwImage255 = sum(f.cdata,3);
    [MaxLines,MaxCols] = size(BwImage255);
    cd('..\DataPatterns');
    imwrite(uint8(BwImage255),'Temp.tif','tif');
    BitmapMatrix = imread('Temp.tif');
    cd('..\Main');
    BitmapMatrix=fliplr(BitmapMatrix');
    [patterns(:,  1),patterns(:,2)] = ...
        find(BitmapMatrix < 200);
    patterns(:,1) = patterns(:,1)/MaxCols;
    patterns(:,2) = patterns(:,2)/MaxLines;
end