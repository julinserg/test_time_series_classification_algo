%------------------------------------------------------------------
%--------- Mixture of Gaussians Modeling --------------------------
%------------------------------------------------------------------
function [MixtWeight, MixtMean, MixtCov, EmRep, Tlapsed,...
        ProbMixt,HPartial] = ...
        PropEMPdfEstim(Patterns,Visualization,VisEMSteps) 
   
global StopByUser 
load('ColorsMatrix.mat'); % A prefixed rand(200,3) mat

% Visualization = 0  'off'
%                 1  'on'

%--------Save to a Movie ------------------------------------------
% SequenceOfFrames = []
% SequenceOfFrames=[SequenceOfFrames getframe(gcf)];
% movie(SequenceOfFrames)
% movie2avi(SequenceOfFrames,filename)
%------------------------------------------------------------------

TStart = clock;                                                                                                    
[NPatterns,Dim] = size(Patterns);
%ArchiveOfModelLikelihood = [];
NMixtures  = 1;
LikelThres = 1e-5;
%----- Initial Parameters of a single Gauss -----------------------
MixtWeight = 1;
MixtMean = mean(Patterns)';
MixtCov = cov(Patterns);

[MixtCovInv, MixtCovDet, MixtCovRank, MixtCovInvCrit, ...
                                MixtCovDetCrit] = InvDet(MixtCov);
 
if (Dim == 1 || Dim == 2) && Visualization == 1
    hold on
    HPartial = CrossLineMixtGaussians(0, 1, MixtMean, MixtCov, ...
                        Patterns, ones(NPatterns,1), ColorsMatrix);
end
%------------ Proceed to the E-M Steps ----------------------------
ProbMixt = zeros( NPatterns, 1);
flag  = 0;        % if flag == 1 no  further split
EmRep = 0;        % Expectation Maximization Repetition
SumLikelModelFinal = 0;

while flag == 0
    EmRep = EmRep +1;

    if StopByUser == 1
        flag=4;
        sprintf('Stoped by User');
    end

    if EmRep ==2500,
        flag=2;
        sprintf('Em repetitions 2500');
    end
    SumLikelModelPrev = SumLikelModelFinal;

    %tic
    [MixtWeight, MixtMean, MixtCov, MixtCovInv, MixtCovDet,...
     MixtCovRank, MixtCovInvCrit, MixtCovDetCrit,...
     SumLikelModelFinal, ProbMixt, ProbMixtInit, ...
     MahalsMixtCrit]  = EMSteps(Patterns, MixtWeight, MixtMean, ...
                  MixtCov, MixtCovInv, MixtCovDet, MixtCovRank, ...
                                   MixtCovInvCrit, MixtCovDetCrit);
    % toc
    
%    ArchiveOfModelLikelihood = [ArchiveOfModelLikelihood ...
%                                              SumLikelModelFinal];


    ModelLikelDiff = SumLikelModelFinal - SumLikelModelPrev;
    if (Dim == 1 || Dim == 2) && Visualization == 1
         title(['EMStep: ' num2str(EmRep) '  Likelihood:' ...
        num2str(SumLikelModelFinal) '  DiffLikelihood:' ...
                                         num2str(ModelLikelDiff)]);
    end
   
    % --------------------- EM convergences -----------------------
    if abs(ModelLikelDiff) < LikelThres * abs(SumLikelModelPrev)...
                                                  || NMixtures == 1
        [MixtWeight, MixtMean, MixtCov, MixtCovRank, MixtCovInv,...
            MixtCovDet, MixtCovInvCrit, MixtCovDetCrit, flag] = ...
              CheckSplitting(Patterns, ...
        MixtWeight, MixtMean, MixtCov, MixtCovRank, MixtCovInv, ...
                  MixtCovDet, MixtCovInvCrit, MixtCovDetCrit, ...
                          ProbMixt, MahalsMixtCrit, Visualization);

        NMixtures = length(MixtWeight);
    end % The Likel diff Stop
    %--------------- End of Stop Split Criterion-------------------
    if (Dim == 1 || Dim == 2) && ...
                  Visualization == 1 && mod(EmRep,VisEMSteps) == 0
          HPartial = CrossLineMixtGaussians(0, MixtWeight,...
              MixtMean, MixtCov, Patterns, ProbMixt, ColorsMatrix);
    end

end   % end EmRep  repetition (by flag)   

if (Dim == 1 || Dim == 2) && Visualization == 1
    HPartial = CrossLineMixtGaussians(1, MixtWeight, MixtMean,...
                         MixtCov, Patterns, ProbMixt,ColorsMatrix);
end
% if Visualization == 1
%     plot(ArchiveOfModelLikelihood')
%     drawnow
% end
    Tlapsed = etime( clock, TStart);
return                          