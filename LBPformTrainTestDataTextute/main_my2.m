%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Authors: Guoying Zhao, Timo Ahonen, Jiri Matas & Matti 
%Pietik?inen (2012)
%Rotation-invariant image and video description with local binary %pattern features. IEEE Transactions on Image Processing, 21%(4):1465-1467

% Copyright @ Center for Machine Vision Research, University of %% Oulu, Finland

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This is an example code how to implement LBPHF_S_M as an %rotation invariant descriptor combining sign and magnitude information with histogram Fourier transform for texture representaion.


clear all;

rootpic = 'd:\bitbucket_proj\phd_codesourse\LBPformTrainTestDataTextute\';
% picture number of the database
% picNum = 4320;  % in Outex_TC_00010
picNum = 8;  % in Outex_TC_00012
sizeParts = 8;
% multiresolution 
scales=[
1 0 0
0 1 0
0 0 1
1 1 0
1 0 1
0 1 1
1 1 1 ];

% change currScale to get multiresolution 
currScale = scales(7,:);

patternMapping1u2 = getmapnew(8,'u2');
patternMapping2u2 = getmapnew(16,'u2');
%patternMapping3u2 = getmapnew(24,'u2');

LBPHF=[];

tic
for i=1:picNum;
    filename = sprintf('%s\\images\\%06d.png', rootpic, i-1);
    Gray = imread(filename);
    Gray = rgb2gray(Gray);
    Gray = double(Gray);
    nrows = size(Gray,1);
    ncols = size(Gray,2);
    ab = reshape(Gray,nrows*ncols,1);
    nColors = 2;
    [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);
    pixel_labels = reshape(cluster_idx,nrows,ncols);
    
    pixel_labels(find(pixel_labels == 1)) = 0;
    pixel_labels(find(pixel_labels == 2)) = 255;
    imshow(pixel_labels);
    imwrite(pixel_labels,sprintf('kmeans%06d.png', i-1))
    Gray = pixel_labels;
        fv1= []; fv2 = []; fv3 = []; fv4 = []; fv5 = []; fv6 = [];

        if(currScale(1))
                    [CLBP_S,CLBP_M,CLBP_C] = clbp(Gray,1,8,patternMapping1u2,'x');
                    % Generate histogram of CLBP_S
                    CLBP_SH= hist(CLBP_S(:),0:patternMapping1u2.num-1);

                    % Generate histogram of CLBP_M
                    CLBP_MH = hist(CLBP_M(:),0:patternMapping1u2.num-1);

                    % Generate LBPHF_S
                    fv1=constructhf(CLBP_SH,patternMapping1u2);

                % Generate LBPHF_M
                    fv2=constructhf(CLBP_MH,patternMapping1u2);

        end

        if(currScale(2))
                    [CLBP_S,CLBP_M,CLBP_C] = clbp(Gray,2,16,patternMapping2u2,'x');

                    % Generate histogram of CLBP_S
                    CLBP_SH= hist(CLBP_S(:),0:patternMapping2u2.num-1);
    %                
                    % Generate histogram of CLBP_M
                    CLBP_MH = hist(CLBP_M(:),0:patternMapping2u2.num-1);
                % Generate LBPHF_S
                    fv3=constructhf(CLBP_SH,patternMapping2u2);

                % Generate LBPHF_M
                    fv4=constructhf(CLBP_MH,patternMapping2u2);

        end

%         if(currScale(3))
%                     [CLBP_S,CLBP_M,CLBP_C] = clbp(Gray,3,24,patternMapping3u2,'x');
%                     % Generate histogram of CLBP_S
%                     CLBP_SH= hist(CLBP_S(:),0:patternMapping3u2.num-1);
% 
%                     % Generate histogram of CLBP_M
%                     CLBP_MH = hist(CLBP_M(:),0:patternMapping3u2.num-1);
%                 % Generate LBPHF_S
%                     fv5=constructhf(CLBP_SH,patternMapping3u2);
% 
%                 % Generate LBPHF_M
%                     fv6=constructhf(CLBP_MH,patternMapping3u2);
% 
% 
%         end
        LBPHF(:,i) = [fv1 fv2 fv3 fv4];
    
       
end
toc

% read picture ID of training and test samples, and read class ID of
% training and test samples
trainTxt = sprintf('%s\\train.txt', rootpic);
testTxt = sprintf('%s\\test.txt', rootpic);
[trainIDs, trainClassIDs] = ReadOutexTxt(trainTxt);
[testIDs, testClassIDs] = ReadOutexTxt(testTxt);
 % classification test 
 trains = LBPHF(:,trainIDs);
 tests = LBPHF(:,testIDs);
[final_accu,PreLabel] = NNClassifier_L1(trains,tests,trainClassIDs,testClassIDs);
PreLabel