function [FirstPatternSet, SecondPatternSet] =  ...
                                    SplitWithDiscriminant(Patterns)
%  Inputs: Patterns 
%  Outputs: FirstPatternSet
%           SecondPatternSet

D          = size(Patterns,2);
CurrentDim = D;
N          = size(Patterns,1);

PoolOfDim = 1:D;

while length(PoolOfDim) ~= 1,    
    FirstDimSet =  1:floor(CurrentDim/2);
    SecondDimSet = (floor(CurrentDim/2)+1):CurrentDim;
   
    if NormalityValue(Patterns, FirstDimSet) > ...
                            NormalityValue(Patterns, SecondDimSet);
          PoolOfDim =  FirstDimSet;
    else
          PoolOfDim =  SecondDimSet;
    end
    CurrentDim = length(PoolOfDim);
end

BestDim = PoolOfDim;
BestDimPatterns = Patterns( : , BestDim );
DisPoint  =  CalcDiscremPoint( BestDimPatterns );

%-----------Plot Module --------------------------------
% figure
% MuBestDimPatterns = mean(BestDimPatterns);
% SigmaBestDimPatterns = sqrt(var(BestDimPatterns));
% 
% BestDimPatterns = sort(BestDimPatterns);
%    
% FxEmp = [1:N]/N;
% FxTheo = normcdf(BestDimPatterns, ...
%                         MuBestDimPatterns, SigmaBestDimPatterns);
% hist( BestDimPatterns,40)
% hold on
% plot( mean(BestDimPatterns) , 0 ,  'g*');
% % plot( DisPoint*[1 1] , [0 1],  'k');
% % 
% % axis([0 1 0 1]);
% pause
% close(gcf)
% close(gcf)
% return
%---------------------------------------------------

IndexToDiscr     = ( Patterns(1:N, PoolOfDim(1)) > DisPoint );
FirstPatternSet  = Patterns(IndexToDiscr,      1:D);
SecondPatternSet = Patterns(IndexToDiscr~=1,1:D);
   

%------------------------------------------------------------------
%----------CalcDiscremPoint----------------------------------------
%------------------------------------------------------------------

function DisPoint  =  CalcDiscremPoint( BestDimPatterns )
        
BestDimPatterns = sort(BestDimPatterns);
Sigma = sqrt( cov( BestDimPatterns));
Mu = mean(BestDimPatterns);
N = size(BestDimPatterns,1);

EmpCDF = (1:N)/N;
TheoCDF = normcdf(BestDimPatterns, Mu, Sigma)';

AbsDiffBetwTheorAndPract = abs( TheoCDF - EmpCDF ) ;
[MaxAbsDiff, IndexMaxAbsDiff] = max(AbsDiffBetwTheorAndPract);
DisPoint = BestDimPatterns(IndexMaxAbsDiff);
     
% figure
% hold on 
% plot(PractCDFvalues(1,:), AbsDiffBetwTheorAndPract  );
% plot(BestDimPatterns, zeros(1,200),  'o');
% plot(PractCDFvalues(1,:), PractCDFvalues(2,:));
% plot(PractCDFvalues(1,:), TheoCDFvalues);
% plot( DisPoint, 0, 'ro');
% close(gcf)

%------------------------------------------------------------------
%----------NormalityValue------------------------------------------
%------------------------------------------------------------------
function SumOfDist = NormalityValue(Patterns, DimSet)

Ns = size(Patterns,1);
D = length(DimSet);
PatternsDim = Patterns(1:Ns, DimSet);
Mu = mean (PatternsDim)';
Sigma2 = cov(PatternsDim);

InvSigma2 = InvDet( Sigma2);

DistPatIndexMixt = PatternsDim - repmat(Mu(1:D, 1)', Ns, 1);
A = DistPatIndexMixt * InvSigma2;
G = sum(A.*DistPatIndexMixt,2);
Mahals(1:Ns) = G;

Mahals = sort(Mahals);
EmpF   = (1:Ns) ./ Ns;
TheoF  = betainc( Ns/(Ns-1)^2 * Mahals, D/2, Ns/2 - D/2 -1/2);
SumOfDist = mean(abs(EmpF - TheoF));
%     figure
%     plot(p, EmpF);
%     hold on 
%     plot(p, F);
%     pause
%     close(gcf)
 return     