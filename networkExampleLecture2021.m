%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EMAT M0021 Transport and Mobility Modelling
% Matlab example
% To be read in conjunction with the "right-arrow" example in the slides.
% NB all this works so nicely because we are using affine costs and
% thus the various objective functions are quadratic (in many variables).
% Matlab has a function which minimises such with respect to linear
% constraints.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% X = quadprog(H,f,A,b) attempts to solve the quadratic programming 
%    problem:
%             min 0.5*x'*H*x + f'*x   subject to:  A*x <= b 
%              x    
%    X = quadprog(H,f,A,b,Aeq,beq) solves the problem above while
%    additionally satisfying the equality constraints Aeq*x = beq. (Set A=[]
%    and B=[] if no inequalities exist.)
%    X = quadprog(H,f,A,b,Aeq,beq,LB,UB) defines a set of lower and upper
%    bounds on the design variables, X, so that the solution is in the 
%    range LB <= X <= UB. Use empty matrices for LB and UB if no bounds 
%    exist. Set LB(i) = -Inf if X(i) is unbounded below; set UB(i) = Inf if 
%    X(i) is unbounded above.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Link-route incidence matrix - NB not the same as the A in the matlab help above
A = [0 1 0 0;...
     0 0 0 1;...
     0 1 0 1;...
     1 0 0 0;...
     0 0 1 0];
numLinks = size(A,1);
numRoutes = size(A,2);
%% Link cost functions a+bx - set up the a and b
a=[2,2,1,4,4]';
b = ones(5,1);
%% OD-route incidence matrix
M = [1 1 0 0;...
     0 0 1 1];
numOD = size(M,1);
%% Demand vector for the two OD pairs
d14 = 1;
d24 = 1;
d = [d14; d24];
%% Node conservation matrix
B = [-1 0 0 -1 0;...
    0 -1 0 0 -1;...
    +1 +1 -1 0 0;...
    0 0 +1 +1 +1];
%% Node conservation vector
s = [-d14 -d24 0 d14+d24]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% UE solution - Beckmann method - route variables.
[yUE,fhat]=quadprog(A'*diag(b)*A,A'*a,[],[],M,d,zeros(numRoutes,1),[])
% compute link flows
xUE=A*yUE
% compute link costs
cUE = a + b.*xUE
% compute route costs
cUEroutes = A'*cUE
% compute total (system) cost
fUE = sum(xUE.*cUE)
% sum(yUE.*cUEroutes) % would do the same thing.
% compute total (system) cost per user:
fUEperuser = fUE/sum(d)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SO solution - route variables
% as for UE solution in route variables - but double the Hessian.
% NB here we are trying to minimise total cost.
[ySO,fSO]=quadprog(2*A'*diag(b)*A,A'*a,[],[],M,d,zeros(numRoutes,1),[])
% compute link flows
xSO=A*ySO
% compute link costs
cSO = a + b.*xSO
% check total total (system) cost - of course, we computed it already!
fSOcheck = sum(xSO.*cSO)
% compute total (system) cost per user
fSOperuser = fSO/sum(d)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% UE solution, Beckmann method, link variables with conservation at nodes.
% NB we don't need to compute any routes at all (magic).
% Thus no need for route-incidence matrix A to convert to link costs.
% Whereas previously M, d ensured route variables add to demands, 
% now B and s ensure flows are conserved at nodes.
[xUE,fhat]=quadprog(diag(b),a,[],[],B,s,zeros(numLinks,1),[])
% NB note this is the same solution as before.
% At this point - you can't usually get back to the route flows,
% because x=A*y and usually, y has more elements than x.
% However, in this simple network, there are fewer routes than links.
yUE = A\xUE 
% is how to do Gauss elim in matlab - in this case, it works uniquely
% and checks with previous answer.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SO solution, link variables with conservation at nodes.
% Exercise!!!
%%