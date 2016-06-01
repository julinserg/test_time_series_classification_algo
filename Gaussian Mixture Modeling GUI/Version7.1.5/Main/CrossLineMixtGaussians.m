
function HPartial= CrossLineMixtGaussians(HoldPlot, MixtWeights,...
       MixtMean, MixtCovs, Patterns, ProbMixt, ColorsMatrix) 

NMixtures         = length(MixtWeights);                 


HCenters     = zeros(1,NMixtures);
HPartial      = zeros(1,NMixtures);
HPartialLines = zeros(1,NMixtures);
HColorPatterns= zeros(1,NMixtures);

[Dummy,MapAssign] = max(ProbMixt,[],2); 

hold on
for IndexMixture = 1:NMixtures
    IndexPatternsPerMixt = find(MapAssign == IndexMixture);
    if ~isempty(IndexPatternsPerMixt)
      HColorPatterns(IndexMixture) = ...
            plot(Patterns(IndexPatternsPerMixt, 1), ...
                 Patterns(IndexPatternsPerMixt, 2),'.',...
                          'Color', ColorsMatrix(IndexMixture,1:3));
    else
        HColorPatterns(IndexMixture) = plot(0,0);
    end
end

%--------------------------------------------------------------
%------- 2D plotting ------------------------------------------
%--------------------------------------------------------------
RadSpots = 80;
RadStep = pi/RadSpots;

domains = [0             :RadStep:pi/2-RadStep      ...   % 1st
           3/2*pi+RadStep:RadStep:2*pi              ...    %2nd
           pi            :RadStep:3*pi/2-RadStep    ...   % 3rd
           pi/2+RadStep  :RadStep:pi-RadStep   0];        % 4th

LengthDomains        =  length(domains);
PPartialMixture      =  zeros(LengthDomains,2,NMixtures);
PPartialMixtureLines =  zeros(2,2,NMixtures);

for IndexMixture = 1: NMixtures
    LengPPartial = 0;
    Sigma = MixtCovs(:,:,IndexMixture);
    AbsSigmaDet = abs( Sigma(1,1)*Sigma(2,2) - Sigma(1,2)^2);
    Likel =  0.9 * 1/2/pi/ sqrt(AbsSigmaDet);

    if AbsSigmaDet == 0
        AbsSigmaDet = eps;
    end

    Mu = MixtMean(:,IndexMixture)';
    Weight   = MixtWeights(IndexMixture);

    LogArg = (Likel/Weight)*2*pi*sqrt(AbsSigmaDet);
    if NMixtures == 1,
        Nomin=-2* AbsSigmaDet*log(LogArg);
    else
        Nomin= 2* AbsSigmaDet*log(LogArg);
    end

    DistAMax = 0;
    DistBMax = 0;
    
    for Theta = domains
        if Theta == pi/2,
            tTh = 10;
        else
            tTh = tan(Theta);
        end
      
        Denom = Sigma(2,2)-2* tTh *Sigma(1,2) + Sigma(1,1)*tTh^2;
        
        if Denom ~= 0
            ND = sqrt(Nomin/Denom);
            xA = Mu(1) + ND;
            xB = Mu(1) - ND;
            yA = tTh*(xA - Mu(1)) + Mu(2);
            yB = tTh*(xB - Mu(1)) + Mu(2);
            if Theta >= 0 && Theta < pi
                PPartialMixture(LengPPartial+1,1:2,IndexMixture)...
                                                         = [xA yA];
        
                DistA=sum((Mu - [xA yA]).^2);
                if DistA > DistAMax
                    DistAMax = DistA;
                  PPartialMixtureLines(1,1:2,IndexMixture)=[xA yA];
                end
            else
                PPartialMixture(LengPPartial+1,1:2,IndexMixture)...
                                                         = [xB yB];
                DistB=sum((Mu - [xB yB]).^2);
                if DistB > DistBMax
                    DistBMax = DistB;
                  PPartialMixtureLines(2,1:2,IndexMixture)=[xB yB]; 
                end
            end
            LengPPartial = LengPPartial + 1;

        end
    end

end  % End Mixtures

hold on
for IndexMixture = 1:NMixtures
    HPartial(IndexMixture)= ...
        plot(real(PPartialMixture(:,1, IndexMixture)'),...
             real(PPartialMixture(:,2, IndexMixture)'), ...
                                    'Color', 'k', 'LineWidth',2);
    HPartialLines(IndexMixture) = ...
        plot(real(PPartialMixtureLines(1:2,1, IndexMixture)),...
             real(PPartialMixtureLines(1:2,2, IndexMixture)),...
                                      'Color', 'k', 'LineWidth',2);
    HCenters(IndexMixture) = ...
      text(real(MixtMean(1,IndexMixture)), ...
           real(MixtMean(2,IndexMixture)),num2str(IndexMixture),...
             'FontSize', 15,'LineWidth', 3, 'BackgroundColor','w');
end 
drawnow

if HoldPlot == 0,
    delete(HPartial);
    delete(HPartialLines);
    delete(HColorPatterns);
    delete(HCenters);
end
hold off
