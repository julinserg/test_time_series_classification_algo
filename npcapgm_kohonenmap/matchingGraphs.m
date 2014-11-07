function [score] = matchingGraphs(G1,W1,G2,W2)
n1 = size(G1,2);
n2 = size(G2,2);
nMax=max(n1,n2);
[target,G2,W2]=permuteIndexes(G2,W2,nMax,nMax);
density_matches=0.000000001;
target=target(1:n1,1:n2);
G1=G1(1:n1,1:n1,:);
G2=G2(1:n2,1:n2,:);
W1=W1(1:n1,1:n1);
W2=W2(1:n2,1:n2);

na=size(G1,3);
F12=ones(n1,n2);
E12=rand(n1,n2)<=density_matches;
E12(target==1)=1;
f.fG=ones(na,1);

options.normalization='none';
W = compute_matchingW(G1,W1,G2,W2,F12,E12,f,options);



options.constraintMode='both'; %'both' for 1-1 graph matching
%options.isAffine=0;% affine constraint
%options.isOrth=0;%orthonormalization before discretization
%options.normalization='iterative';%bistochastic kronecker normalization
 options.normalization='none'; %we can also see results without normalization
%options.discretisation=@discretisationGradAssignment; %function for discretization
%options.is_discretisation_on_original_W=0;

%put options.is_discretisation_on_original_W=1 if you want to discretize on original W 
%1: might be better for raw objective (based orig W), but should be worse for accuracy

%% graph matching computation
[X12,X_SMAC,timing]=compute_graph_matching_SMAC(W,E12,options);

%% results evaluation
if n1>n2
    dim=1;
else
    dim=2;
end
[ignore,target_ind]=max(target,[],dim);
[ignore,X12_ind]=max(X12,[],dim);
nbErrors=sum(X12_ind~=target_ind)/length(target_ind);

score=computeObjectiveValue(W,X12(E12>0));



function [target,G2,W2]=permuteIndexes(G2,W2,n1,n2);
% perm=randperm(n1);
perm=1:n1;
G2=G2(perm,perm,:);
W2=W2(perm,perm);
target=ind2perm(perm);


function [G1,W1]=computeRandomGraph(n1,param);
na=param.na;
ratio_fill=param.ratio_fill;
W1 = sprand(n1,n1,ratio_fill)>0;
G1=computeAttributes(W1,na);

function [G2,W2]=perturbGraph(n2,G1,W1,noise);
[n1,n1,na]=size(G1);
if n1~=n2
    error('TODO');
end

Wnoise=sprand(n2,n2,noise.noise_edges)>0;
Gnoise_add=computeAttributes(Wnoise,na);
Gnoise_self=computeAttributes(W1,na);
W2=W1|Wnoise;
Gnoise = Gnoise_add*noise.noise_add + Gnoise_self*noise.noise_self;
G2 = G1 + Gnoise;

function G1=computeAttributes(W1,na);
n1=length(W1);
[indi,indj]=find(W1);
ne=length(indi);
for a=1:na
    vala=rand(ne,1);
    %     vala=randn(ne,1);
    G1(:,:,a)=accumarray([indi,indj],vala,[n1,n1]);
end