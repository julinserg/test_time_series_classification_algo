function [theta, J_history] = gradientDescent(X, y, theta, alpha, num_iters)
%GRADIENTDESCENT Performs gradient descent to learn theta
%   theta = GRADIENTDESENT(X, y, theta, alpha, num_iters) updates theta by 
%   taking num_iters gradient steps with learning rate alpha

% Initialize some useful values
m = length(y); % number of training examples
J_history = zeros(num_iters, 1);
%theta = repmat(0.00000001,size(theta,1),size(theta,2));
for iter = 1:num_iters

    % ====================== YOUR CODE HERE ======================
    % Instructions: Perform a single gradient step on the parameter vector
    %               theta. 
    %
    % Hint: While debugging, it can be useful to print out the values
    %       of the cost function (computeCost) and gradient here.
    %
    thetaTemp = theta;
    for j = 1:size(theta,1)
       sumG = 0;
       for i = 1:m       
           sumG = sumG + (theta'*X(i,:)'-y(i))*X(i,j);
       end;       
       thetaTemp(j) =  theta(j) - (alpha/m)*sumG;
        
    end;
    theta = thetaTemp;

    % ============================================================

    % Save the cost J in every iteration    
    J_history(iter) = computeCost(X, y, theta);   

end

end