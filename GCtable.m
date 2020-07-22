% %%%% GCtable Function %%%%
% Author: Ehsan Fazel (Concordia University)
% This version: September 2019

function [GC_table] = GCtable(data)
%GCtable Summary: 
% This function returns the causality table for a set of vectors. It uses 
% the definition of the causality measure presented in Dufour and Taamouti
% (2010) and obtains the measure for the first horizon. VAR of order 1 is
% used in the computation. Estimation method is equation by equation. Each 
% row of the table shows the measue from the row i to others. 

%input: data. a T by N matrix, N is the number of variables

%1st step: building the unconstrained model
unrest_VAR = data;
Y1 = unrest_VAR(2:end,:); %vectors on the left-hand side/ the unrestricted VAR
X1 = unrest_VAR(1:end-1,:); %vectors on the right-hand side/ the unrestricted VAR 
n_obs = size(Y1,1); %number of observations
n_expl = size(Y1,2); %number of vectors
unr_residuals = zeros(n_obs,n_expl);
for j=1:n_expl
    
    y = Y1(:,j);
    X11 = [ones(size(X1,1),1),X1];
    [b,bint,r] = regress(y,X11);
    unr_residuals(:,j) = r; 
    
end

%2nd step: building the constrained model


    rest_VAR = data;
    Y2 = rest_VAR(2:end,:); %vectors on the left-hand side
    X2 = rest_VAR(1:end-1,:); %vectors on the right-hand side
    n_obs = size(Y2,1); %number of observations
    n_expl = size(Y2,2); %number of vectors
for k=1:n_expl
    
    rest_X = X2;
    rest_X(:,k) = []; %remove one vector at a time
    rest_residuals = zeros(n_obs,n_expl);
    for j=1:n_expl
        
        y = Y2(:,j);
        intc = ones(size(rest_X,1),1);
        XX = [intc,rest_X];
        [b,bint,r] = regress(y,XX);
        rest_residuals(:,j) = r;
        
    end
   REST_RESIDUALS{1,k} = rest_residuals;
   clear rest_X 
end

% 3rd step: calculating the causality table

    unrst_r = unr_residuals; %unrestricted r for month k
    unrst_cov = cov(unrst_r); %get the cov matrix
    unrst_var = diag(unrst_cov); %choose only the diagonal as variance for denominator of GC
    M = size(unrst_r,2);
    GC_table = zeros(M,M);
    for i=1:M
        rst_r = REST_RESIDUALS{1,i};
        rst_cov = cov(rst_r);
        rst_var = diag(rst_cov);
        N = size(rst_r,2);
        causality = log(rst_var./unrst_var);
        causality = causality';
        GC_table(i,:) = causality;
        GC_table(GC_table<0) = 0;
        GC_table(isnan(GC_table)) = 0;
    end

  
    
end

