function [arrayLL] = npmpgm_kmeans_test(Probability,cellNetKox,dataTest)
%% ������� �������������
% ������� ������:
%       Probability - ������ �����((Nx1)- N - ���������� �������), ������ ������ ��� ������� �������� ������������� ������������ ��������
%       ����� ������ ����� ��������: LxL - ��� L =row_map*col_map
%       cellNetKox - ������ �������� ��������� ���� ����� ����� �������� ���
%       ������� ������: (Nx1)- N - ���������� �������
%       dataTest -������ ����� (cell) ��������� ������ ��� ������������, - 1xM,
%       ��� M - ���������� �������� ��������,������ ������ �������� 
%       ��������� ������������������� DxT - D - ����������� ������ ���������
%       , T - ����� ������������������
% �������� ������:
%       arrayLL - ������ �������� ������������� (NxM) - N - ����������
%       �������, M - ���������� �������� ��������
%%
for i = 1:size(dataTest,1)
    p = dataTest{i};
    for m = 1:size(cellNetKox,1)
       w= cellNetKox{m};       
       [S,R11] = size(w);
       [R2,Q] = size(p);
       z = zeros(S,Q);
       w = w';
       copies = zeros(1,Q);
       for ii=1:S
         z(ii,:) = sum((w(:,ii+copies)-p).^2,1);
       end;
       n = -z.^0.5;
       %z = -z.^2;
       %n= -z;
       B = exp(n);
       [maxn,rows] = max(n,[],1);
       pih = repmat(5,1,size(w',1));
       pih(1,rows(1,1)) = 10;
       pih = normalizeLogspace(pih);
       pih = exp(pih);
       A =  Probability{m}.A;
       % hmmFilter - ������� �� matlab-������ Probabilistic Modeling Toolkit for
       % Matlab/Octave https://github.com/probml/pmtk3
       %logp = hmmFilter(pih, A, B);
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
       %logp2 = A( rows(1), rows(1) ) * B( rows(1), 1 );      
       %for ii=1:S
       % for jj=1:S
       %     for t=2:Q
       %         logp2 = logp2 + (  A( ii, jj ) * B( jj, t ) );
       %     end
       % end
       %end
       %logp2 = log (logp2);
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
       [K T] = size(B);   
       scale = zeros(T,1);
       alpha = zeros(K,T); 
       AT = A';
       [alpha, scale(1)] = normalize(pih(:) .* B(:,1));
       for t=2:T
           [alpha, scale(t)] = normalize((AT * alpha) .* B(:,t));
       end
       logp = sum(log(scale+eps));
       %logp2 = log(prob_all);
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       arrayLL(i,m) = logp;          
    end;
end;
arrayLL = arrayLL';