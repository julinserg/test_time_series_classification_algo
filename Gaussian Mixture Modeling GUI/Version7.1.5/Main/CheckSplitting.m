function [MixtWeight,MixtMean,MixtCov, MixtCovRank, MixtCovInv,...
          MixtCovDet, MixtCovInvCrit, MixtCovDetCrit, flag] = ...
          CheckSplitting(Patterns, MixtWeight,...
         MixtMean, MixtCov, MixtCovRank, MixtCovInv, MixtCovDet,...
         MixtCovInvCrit, MixtCovDetCrit, ...
               ProbMixt, MahalsMixtCrit, Visualization)  
                 
flag = 0;                  
[NPatterns, NMixtures] = size(ProbMixt);
Dim = size(Patterns,2);                  
                  
MapAssign           = zeros(1, NPatterns); 
MahalSample         = zeros(1, NPatterns); 
AreaProbMixt        = zeros(NPatterns, NMixtures);
NPatternsPerMixt    = zeros(1,NMixtures);
Kurtosis            = zeros(1,NMixtures);
Departures          = zeros(1,NMixtures);
lambda              = zeros(1,NMixtures);
 
%------------------------------------------------------------------
%-----------------------E) Assign Step ----------------------------
%------------------------------------------------------------------

AreaProbMixt(1:NPatterns, 1) = ProbMixt(1:NPatterns, 1);
for IndexMixtures  = 2:NMixtures
    AreaProbMixt(1:NPatterns, IndexMixtures ) = ...
               AreaProbMixt(1:NPatterns, IndexMixtures-1) +...
                              ProbMixt(1:NPatterns, IndexMixtures);
end

Dice0to1 = rand(NPatterns,1);

IndexBigger  = (AreaProbMixt   >=  repmat(Dice0to1,1,NMixtures) );
IndexSmaller = (AreaProbMixt   <    repmat(Dice0to1,1,NMixtures));
DiffIndex = IndexBigger -  IndexSmaller;

for IndexPattern =1:NPatterns
    Assign = find( DiffIndex(IndexPattern,:) >0) ;
    MapAssign( IndexPattern ) = Assign(1) ;
    MahalSample(IndexPattern) = MahalsMixtCrit(...
                          IndexPattern, MapAssign( IndexPattern ));
end

 
for IndexMixture =1: NMixtures
    MahalSampleMixt = MahalSample(MapAssign == IndexMixture);
    NPatternsPerMixt(IndexMixture) = length(MahalSampleMixt);

    if NPatternsPerMixt( IndexMixture  ) > 100
        lambda(IndexMixture) = 0.01;
    elseif NPatternsPerMixt(IndexMixture)>20 && ...
                               NPatternsPerMixt(IndexMixture)<=100,
        lambda(IndexMixture)  = 0.05;
    elseif NPatternsPerMixt(IndexMixture)<=20
        lambda(IndexMixture) = 0.1;
    end

    % The number of samples in a mixture should be more than 
    % the dimensionality and the determinant not zero
    if length(MahalSampleMixt)/2-MixtCovRank(IndexMixture)/2 ...
             -1/2>0 && MixtCovDet(IndexMixture) > 1e-15
        Kurtosis(IndexMixture)=1/NPatternsPerMixt(IndexMixture)*...
                                           sum(MahalSampleMixt.^2);
        
        Departures(IndexMixture) = SplitCriterion(...
                  MixtCovRank(IndexMixture), IndexMixture,...
                           MahalSampleMixt, lambda(IndexMixture) );
    else
        Departures(IndexMixture) = 0;
        lambda(IndexMixture)     = 0;
        Kurtosis(IndexMixture)   = 0;
    end
end % Mixtures
%------------------------------------------------------
%------------------B) -C) Splitting -----------------
%------------------------------------------------------
[MaxDepart,MaxDepartIndex]=max(Departures- ...
                                         lambda.*NPatternsPerMixt);
                
if  MaxDepart > 0
    IndexMixtToSplit  = MaxDepartIndex;
    IndicesMixtNotToSplit = [1:IndexMixtToSplit-1 ...
                                     IndexMixtToSplit+1:NMixtures];
    NewNMixtures    = NMixtures + 1 ;
    NewMixtWeight   = zeros(1,NewNMixtures);
    NewMixtMean     = zeros(Dim, NewNMixtures);
    NewMixtCov      = zeros(Dim, Dim, NewNMixtures);
    NewMixtCovRank  = zeros(1,NewNMixtures);
    NewMixtCovInv   = zeros(Dim, Dim, NewNMixtures);
    NewMixtCovDet   = zeros(1,NewNMixtures);
    NewMixtCovInvCrit= zeros(Dim, Dim, NewNMixtures);
    NewMixtCovDetCrit= zeros(1,NewNMixtures);
    
    CountNewMixt    = 0;
                        
    %------------------- Keep the Mixtures not to split ----------

    for IndexMixture =  IndicesMixtNotToSplit
        CountNewMixt = CountNewMixt + 1;
        NewMixtWeight(CountNewMixt)     = MixtWeight(IndexMixture);
        NewMixtMean(1:Dim, CountNewMixt) = ...
                                     MixtMean(1:Dim, IndexMixture);
        NewMixtCov(1:Dim, 1:Dim, CountNewMixt) = ...
                               MixtCov(1:Dim, 1:Dim, IndexMixture);
        NewMixtCovRank(CountNewMixt) = MixtCovRank(IndexMixture);
        NewMixtCovInv(1:Dim, 1:Dim, CountNewMixt) = ...
                           MixtCovInv(1:Dim, 1:Dim,  IndexMixture);
        NewMixtCovDet(CountNewMixt) = MixtCovDet(IndexMixture);
        NewMixtCovInvCrit(1:Dim, 1:Dim, CountNewMixt) = ...
                           MixtCovInv(1:Dim, 1:Dim,  IndexMixture);
        NewMixtCovDetCrit(CountNewMixt) = MixtCovDet(IndexMixture);
    end
    %-------------------- Mixture to Split ------------------------
    PatternsPerMixtureToSplit    = ...
                     Patterns(MapAssign == IndexMixtToSplit,1:Dim);
    NPatternsToSplit          = size( PatternsPerMixtureToSplit,1);
    EK = (1 - 1/NPatternsToSplit)^2 * ...
        (NPatternsToSplit-1)/(NPatternsToSplit+1)*Dim*( Dim + 2);

    if Kurtosis(IndexMixtToSplit) < EK  % Kurtosis Switch
%         if Visualization == 1
%             disp('Split with discriminant');
%         end
        % -------------- Split for 2 Mixtures ---------------------
        [FirstSplitSet, SecondSplitSet] = SplitWithDiscriminant(...
                                        PatternsPerMixtureToSplit);
            
         if size(FirstSplitSet,1) == 0 || size(SecondSplitSet,1)==0
            if Visualization == 1
                 sprintf(['Discriminant failed. Probably' ... 
                           'non-Gaussian mixture model. Random.']);
            end
            IndexRand     = randperm(NPatternsToSplit);
            FirstSplitSet = PatternsPerMixtureToSplit(...
                 IndexRand(1:floor(NPatternsToSplit/2)), 1:Dim);
            SecondSplitSet= PatternsPerMixtureToSplit(...
                 IndexRand(floor(NPatternsToSplit/2)+1:end),1:Dim);
        end

        
        CountNewMixt                        = CountNewMixt + 1;
        NewMixtMean(1:Dim,CountNewMixt)     = mean(FirstSplitSet)';
        NewMixtCov(1:Dim,1:Dim,CountNewMixt)= cov(FirstSplitSet);
        NewMixtCovRank(CountNewMixt)        = Dim;
        NewMixtWeight(CountNewMixt)      = size(FirstSplitSet,1)...
                  /NPatternsToSplit * MixtWeight(IndexMixtToSplit);

        [NewMixtCovInv(1:Dim,1:Dim,CountNewMixt), ...
            NewMixtCovDet(CountNewMixt), ...
            NewMixtCovRank(CountNewMixt), ...
            NewMixtCovInvCrit(1:Dim,1:Dim,CountNewMixt), ...
            NewMixtCovDetCrit(CountNewMixt)] = ...
                     InvDet( NewMixtCov(1:Dim,1:Dim,CountNewMixt));

        CountNewMixt                        = CountNewMixt + 1;
        NewMixtCovRank(CountNewMixt)        = Dim;
        NewMixtMean(1:Dim,CountNewMixt)     =mean(SecondSplitSet)';
        NewMixtCov(1:Dim,1:Dim,CountNewMixt)=cov(SecondSplitSet);
        NewMixtWeight(CountNewMixt)    = size(SecondSplitSet,1) ...
                  /NPatternsToSplit * MixtWeight(IndexMixtToSplit);
        [NewMixtCovInv(1:Dim,1:Dim,CountNewMixt), ...
          NewMixtCovDet(CountNewMixt), ...
           NewMixtCovRank(CountNewMixt),...
            NewMixtCovInvCrit(1:Dim,1:Dim,CountNewMixt), ...
             NewMixtCovDetCrit(CountNewMixt)] = ...
                    InvDet( NewMixtCov(1:Dim,1:Dim,CountNewMixt));
    else
%       if Visualization == 1
%           disp('Split by setting centers on the original center')
%       end

        CountNewMixt                   = CountNewMixt + 1;
        NewMixtMean(1:Dim,CountNewMixt)= MixtMean(1:Dim, ...
                                                 IndexMixtToSplit);
        for d = 1:Dim
            NewMixtCov(d,d,CountNewMixt) = ...
                sqrt(MixtCovDet(IndexMixtToSplit)) ...
             /Dim/(NPatternsToSplit-1)*chi2rnd(NPatternsToSplit-1);
        end
        NewMixtWeight(CountNewMixt)=MixtWeight(IndexMixtToSplit)/2;
        [NewMixtCovInv(1:Dim,1:Dim,CountNewMixt), ...
          NewMixtCovDet(CountNewMixt), ...
           NewMixtCovRank(CountNewMixt), ...
            NewMixtCovInvCrit(1:Dim,1:Dim,CountNewMixt), ...
             NewMixtCovDetCrit(CountNewMixt)] = ...
                     InvDet( NewMixtCov(1:Dim,1:Dim,CountNewMixt));


        CountNewMixt                    = CountNewMixt + 1;
        NewMixtMean(1:Dim,CountNewMixt) = MixtMean(1:Dim, ...
                                                 IndexMixtToSplit);
        for d = 1:Dim
            NewMixtCov(d,d,CountNewMixt)= ...
                          sqrt( MixtCovDet(IndexMixtToSplit) )...
             /Dim/(NPatternsToSplit-1)*chi2rnd(NPatternsToSplit-1);
        end
        NewMixtWeight(CountNewMixt)=MixtWeight( IndexMixtToSplit)/2;
        [NewMixtCovInv(1:Dim,1:Dim,CountNewMixt), ...
                         NewMixtCovDet(CountNewMixt), ...
                             NewMixtCovRank(CountNewMixt),...
           NewMixtCovInvCrit(1:Dim,1:Dim,CountNewMixt), ...
            NewMixtCovDetCrit(CountNewMixt)] = ...
                     InvDet( NewMixtCov(1:Dim,1:Dim,CountNewMixt));
    end % Kurtosis switch
    %--------------- Make Loop  --------------
    MixtWeight     = NewMixtWeight;
    MixtMean       = NewMixtMean;
    MixtCov        = NewMixtCov;
    MixtCovRank    = NewMixtCovRank;
    MixtCovInv     = NewMixtCovInv;
    MixtCovDet     = NewMixtCovDet;
    MixtCovInvCrit = NewMixtCovInvCrit;
    MixtCovDetCrit = NewMixtCovDetCrit;    
    %------------- end split -----------------
else
    flag = 1;     % No Split, Stop EM
end    %    End Splitting

return


%------------------------------------------------------------------
%-------------------Criterion for Spliting Mixtures----------------
%------------------------------------------------------------------
function [DepartCount]= SplitCriterion(D, IndexMixture, ...
                                               MahalSample, lambda)
    Ns = length(MahalSample);
    if Ns < 10
        DepartCount = 0;
        return
    end
    MahalSample = sort(MahalSample);  
    B01 =  Ns/(Ns-1)^2 * MahalSample;
    B01( B01 > 1) = 1;     % Numerical errors
    B01( B01 < 0) = 0;
   
    TheoF = betainc( B01 , D/2, Ns/2 - D/2 -1/2);

    EmpF   = (1:Ns)./ Ns;  
    DwUp   = FastBinoInv(lambda,  TheoF );
    Depart = [find( EmpF(2:end-1) > DwUp(2,:)) ...
              find( EmpF(2:end-1) < DwUp(1,:) )];
    DepartCount = length(Depart);
%---------- Plot Module ------------------------------
%   figure 
%   plot(MahalSample, TheoF, 'Color', [.2 .2 .2])
%   hold on
%   plot(MahalSample,EmpF,'-', 'Color', [.2 .2 .2])
%   plot(MahalSample(2:end-1), DwUp(2,:) ,'-','Color', [.9 .9 .9])
%   plot(MahalSample(2:end-1), DwUp(1,:) ,'-', 'Color', [.6 .6 .6])
%   plot(MahalSample(Depart), EmpF(Depart),'+', 'Color', [0 0 0]);
%   axis([min(MahalSample) max(MahalSample) 0 1])
%   title([num2str(IndexMixture)]);
%   drawnow
%   pause
%   close(gcf)
return


