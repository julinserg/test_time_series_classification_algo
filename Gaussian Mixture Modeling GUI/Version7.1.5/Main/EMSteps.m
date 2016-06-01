function [MixtWeight, MixtMean, MixtCov, MixtCovInv, MixtCovDet,...
MixtCovRank, MixtCovInvCrit, MixtCovDetCrit, SumLikelModelFinal,...
  ProbMixt, ProbMixtInit, MahalsMixtCrit] =  EMSteps(Patterns,...
   MixtWeight, MixtMean, MixtCov, MixtCovInv, MixtCovDet, ...
                       MixtCovRank, MixtCovInvCrit, MixtCovDetCrit)   


%diagnostics       = 0;       
[NPatterns, Dim]  = size(Patterns);
NMixtures         = length(MixtWeight);

ProbMixtInit      = zeros( NPatterns, NMixtures);
MahalsMixtCrit    = zeros( NPatterns, NMixtures);   

GaussConst        = (2*pi).^(MixtCovRank/2); % vector (1:NMixtures)
%------------------------ Case of 1 Gaussian ----------------------
if NMixtures == 1
    MixtWeGaussAbsMixtCovDet = 1/GaussConst/sqrt(abs(MixtCovDet));
    DistPatIndexMixt = Patterns - ...
                          repmat(MixtMean(1:Dim,1)', NPatterns, 1);
    A = DistPatIndexMixt * MixtCovInv;
    G = sum(A.*DistPatIndexMixt,2);
    ProbMixtInit(1:NPatterns) = ...
                            MixtWeGaussAbsMixtCovDet*exp( -0.5* G);
    ZeroProbMixt= [find( ProbMixtInit(1:NPatterns) < eps)' ...
                   find( isnan(ProbMixtInit(1:NPatterns)))' ...
                   find( ProbMixtInit(1:NPatterns) == Inf)'];
    ProbMixtInit(ZeroProbMixt) = eps;

    ProbMixt = ones(NPatterns,1);
    SumLikelModelFinal = sum( log( ProbMixtInit(1:NPatterns) ));
    if MixtCovRank < Dim
        ACrit = DistPatIndexMixt * MixtCovInvCrit;
        GCrit = sum(ACrit.*DistPatIndexMixt,2);
        MahalsMixtCrit(1:NPatterns) = GCrit;
    else
        MahalsMixtCrit = G;
    end
    return
end
%------------------------------------------------------------------    

%------------------------------------------------------------------
%----------------------- Calculate E-Step--------------------------
%------------------------------------------------------------------

% if sum(GaussConst == 0) > 0 || sum(MixtCovDet < eps) >0 
% %    diagnostics = 0;
%     IndexZeroDet = find(MixtCovDet < eps);
%     for IndxIndxZeroDet = IndexZeroDet
%         MixtCovDet(IndxIndxZeroDet) = eps;
%         MixtCovInv(1:Dim, 1:Dim, IndxIndxZeroDet) = ...
%                                              eps* ones(Dim, Dim);
%         MixtCovRank(IndxIndxZeroDet) = 0;
%     end
% end

MixtWeGaussAbsMixtCovDet = MixtWeight./GaussConst./ ...
                                             sqrt(abs(MixtCovDet));

% if diagnostics == 1
%     sprintf('Before E-Step')
%     GaussConst
%     MixtCovDet
% end    

for IndexMixture =1: NMixtures,
    DistPatIndexMixt = Patterns - ...
               repmat(MixtMean(1:Dim,IndexMixture)', NPatterns, 1);
    A = DistPatIndexMixt * MixtCovInv(1:Dim,1:Dim, IndexMixture);
    G = sum(A.*DistPatIndexMixt,2);
    ProbMixtInit(1:NPatterns, IndexMixture) = ...
        MixtWeGaussAbsMixtCovDet(IndexMixture)*exp( -0.5* G);
       ZeroProbMixt = ...
        [find(ProbMixtInit(1:NPatterns, IndexMixture) < eps )' ...
         find(isnan(ProbMixtInit(1:NPatterns, IndexMixture)))' ...
         find(ProbMixtInit(1:NPatterns, IndexMixture) == Inf)'];

    ProbMixtInit(ZeroProbMixt, IndexMixture) = eps;
    if MixtCovRank(IndexMixture) < Dim
        ACrit = DistPatIndexMixt * MixtCovInvCrit(1:Dim,1:Dim, ...
                                                     IndexMixture);
        GCrit = sum(ACrit.*DistPatIndexMixt,2);
        MahalsMixtCrit(1:NPatterns, IndexMixture) = GCrit;
    else
        MahalsMixtCrit(1:NPatterns, IndexMixture) = G;
    end
end

ProbMixt = ProbMixtInit./repmat(sum(ProbMixtInit,2), 1, NMixtures);

S = zeros(1,NMixtures);
for IndexMixture = 1:NMixtures
    S(IndexMixture) = ProbMixt(1:NPatterns, IndexMixture)' * ...
        log( ProbMixtInit(1:NPatterns, IndexMixture) );
end
SumLikelModelFinal = sum(S);

% if isnan(SumLikelModelFinal)
%     diagnostics = 1;
% end

% if diagnostics == 1
%     sprintf('After E-Step')
%     SumLikelModelFinal
%     S
%     ProbMixtInit
%     ProbMixt
%     pause
% end
       

%-----------------------------------------------------------
%---------------------Calculate M-Step ---------------------
%-----------------------------------------------------------
SumLikelforMixt =sum(ProbMixt,1);

for IndexMixture =1: NMixtures,
    if  SumLikelforMixt > eps/1000
        MixtWeight(IndexMixture)=1/NPatterns* ...
                                     SumLikelforMixt(IndexMixture);
        MixtMean(1:Dim,  IndexMixture) = ...
                 ProbMixt(1:NPatterns, IndexMixture)'* Patterns/...
                                     SumLikelforMixt(IndexMixture);
        DistPatIndexMixt = Patterns - ...
               repmat(MixtMean(1:Dim,IndexMixture)', NPatterns, 1);

        MixtCov(1:Dim, 1:Dim, IndexMixture) = ...
             (repmat(ProbMixt(1:NPatterns, IndexMixture)', ...
               Dim,1).*DistPatIndexMixt') * DistPatIndexMixt ...
                ./ repmat(SumLikelforMixt(IndexMixture), Dim, Dim);

            
       [MixtCovInv(1:Dim, 1:Dim, IndexMixture), ...
          MixtCovDet(IndexMixture), MixtCovRank(IndexMixture), ...
                MixtCovInvCrit(1:Dim, 1:Dim, IndexMixture), ...
                    MixtCovDetCrit(IndexMixture)] = ...
                      InvDet( MixtCov(1:Dim, 1:Dim, IndexMixture));
    end % Check  SumLikel for Mixture to be great enough
end   % End IndexMixture for M-Step

% if diagnostics == 1
%     sprintf('After M-Step')
%     MixtCovInv
%     MixtCovDet
%     MixtCovRank
% end
return          
