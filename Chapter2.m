%% Linear Regression Models

%% Load data
load('S02_MedData.mat');

%% Visualise the dependency of pulse pressure on age
x = MedData.Age;
y = MedData.BPDiff;
figure
scatter(x, y, 'bx')
xlabel('Age')
ylabel('Pulse Pressure')
title('\bfPulse Pressure vs. Age')

% This dependency looks as if it could be modelled using a quadratic curve
% (i.e. using a model of the form PP ~ C0 + C1*Age + C2*Age.^2, where the
% coefficients C0, C1 and C2 are unknown and to be determined).

%% Matrix Equations
% Formulating a linear regression model leads to a system of linear
% equations A*x = b for the unknown vector of coefficients x. The design
% matrix A comprises the model terms, and the vector b is the data to be
% modelled (in this example, the vector of pulse pressure observations).

% Because solving these linear systems is a matrix operation any missing
% values in the data must be removed before trying to solve the system.
missingIdx = isnan(x) | isnan(y);
xClean = x(~missingIdx);
yClean = y(~missingIdx);
designMat = [ones(size(xClean)), xClean, xClean.^2];

%% Slash and Backslash.
% The least-squares solution of the system A*x = b in MATLAB is given by 
% x = A\b. If the system is formulated as x*A = b, then its solution is
% x = b/A. 

% Solve the linear system to find the best-fit coefficients for modelling
% pulse pressure as a quadratic function of age.
modelCoeffs = designMat\yClean;

% Compute the fitted model.
pulseModel = designMat*modelCoeffs;

% Visualise the results
hold on
plot(xClean, pulseModel, 'r*')
hold off

%% Matrix and Array Operations
% Note that in the above computations we have used the operators * and \.
% A complete list of matrix, array and logical operators is available by
% entering the command >> doc ops.

doc ops

%% Generalising the Model
% Generalise to fit a two-dimensional quadratic surface to a single
% response variable given two input variables. In this case we will try to
% predict weight given height and waist measurements.

% Extract input variables.
x1 = MedData.Height;
x2 = MedData.Waist;

% Extract output variable.
y = MedData.Weight;

% Clean the data.
missingIdx = isnan(x1) | isnan(x2) | isnan(y);
x1Clean = x1(~missingIdx);
x2Clean = x2(~missingIdx);
yClean = y(~missingIdx);

% Formulate the system of linear equations.
designMat = [ones(size(x1Clean)), x1Clean, x2Clean, x1Clean.^2, ...
             x2Clean.^2, x1Clean.*x2Clean];
         
% Solve the system.                 
modelCoeffs = designMat\yClean;

%% Function Handles
% Now that we have the second set of model coefficients for the 2D
% quadratic model, we would like to visualise the fitted results. To do
% this, we need to substitute the model coefficients into the model
% equation. One way to achieve this is to use a function handle, which is a
% variable containing a reference to a function. Using a function handle
% reduces the problem of calling a function to that of accessing a
% variable. The function handle contains all information necessary to
% evaluate the function at given input arguments. For further information
% on function handles, see MATLAB -> Language Fundamentals -> Data Types ->
% Function Handles.

modelFun = @(c, x1, x2) c(1) + c(2)*x1 + c(3)*x2 + c(4)*x1.^2 + ...
                        c(5)*x2.^2 + c(6)*x1.*x2;
                    
disp(modelFun(modelCoeffs, 150,100))

%% Creating Equally-Spaced Vectors
% In order to visualise the data create a set of equally spaced points in
% the range of the x and y data (forming the horizontal plane)
x1Vec = linspace(min(x1Clean), max(x1Clean));
x2Vec = linspace(min(x2Clean), max(x2Clean)); 

%% Making Grids
% Create matrices containing the coordinates of all grid points in the
% lattice
[X1Grid, X2Grid] = meshgrid(x1Vec, x2Vec);

% Evaluate the function for the lattice of points using the function handle
YGrid = modelFun(modelCoeffs, X1Grid, X2Grid);

%% Surface Plots
figure
surf(X1Grid, X2Grid, YGrid)
% Customise the display by adding name-value pairs
surf(X1Grid, X2Grid, YGrid,'FaceColor', 'interp', 'EdgeAlpha', 0);

% View the original data
hold on
plot3(x1Clean, x2Clean, yClean, 'kx')
xlabel('Height (cm)')
ylabel('Waist (cm)')
zlabel('Weight (kg)')
title('\bfModel for Weight vs. Height and Waist')

%% Creating a Function
% Create a function which will automate the steps in the script so far
% Functions are created in text files with the .m extension, just like
% script files. However, functions must begin with a function declaration
% of the form:
% function [out1, out2, ...] = function_name(in1, in2, ...)
% The keyword "function" must be the first non-comment code in the file.
% Syntax for calling user-defined functions is identical to that used for
% calling existing MATLAB functions.

load('S02_MedData.mat');
x_Age = MedData.Age;
y_BPDiff = MedData.BPDiff;
[modelCoeffs, fh] = fitQuadModel( x_Age, y_BPDiff, false);

%% Workspaces
% Functions operate within their own function workspace, which is separate
% from the base workspace accessed at the prompt or from within scripts. If
% a function calls another function, each maintains its own separate
% workspace. Once a function has completed, its workspace is destroyed.

%% Local Functions.
% There may be times when we wish to outsource certain tasks in a function
% to another function. For example, if we think about our algorithm at a
% high-level, we are performing three distinct tasks:
% * we are cleaning up the data by removing NaNs;
% * we are performing the model fitting;
% * we are visualising the results of the fitted model.
%
% We are performing these three tasks on two distinct sets of data. One
% possibility for structuring our main function is to have three local
% functions defined inside, each of which represents one of the three tasks
% above. This enables us to reuse the same function for multiple different
% sets of data.

%% Call function with one set of x data
x = MedData.Age;
y = MedData.BPDiff;
[Coefs, fh] = fitQuadModel( x, y, true);

%% Call function with two sets of x data
x = [MedData.Height, MedData.Waist];
y = MedData.Weight;
[Coeffs, fh] = fitQuadModel( x,y, true);

%% Defining Flexible Interfaces
% As we have written it, the fitQuadModel function requires three inputs,
% the X data, the y data, and a logical flag indicating whether or not the
% data should be plotted. MATLAB will return an error message unless
% exactly three inputs are provided whenever fitQuadModel is called.
% We can use the NARGIN function to determine how many input arguments were
% provided when the function was called. With this information, we can set
% default input values if necessary.
[Coeffs, fh] = fitQuadModel( x, y);

%% Checking Input Arguments
% Error conditions often arise because run-time values violate certain
% implicit assumptions made in code. When designing algorithms, especially
% those that will be used by others, it is important to catch any
% user-introduced errors. These may not become apparent until later on in
% the code. In a weakly-typed language such as MATLAB, checking types and
% attributes of user-supplied input data is particularly important.
% Recommended approaches include using the family of is* functions (see doc
% is*) and the more sophisticated function VALIDATEATTRIBUTES.

%[Coeffs, fh] = fitQuadModel( x);
%[Coeffs, fh] = fitQuadModel( [], y);
%[Coeffs, fh] = fitQuadModel( x, x);
%[Coeffs, fh] = fitQuadModel( [], y);
%[Coeffs, fh] = fitQuadModel( x, y, 1:4);

%% Errors and Error Identifiers.
% When unexpected conditions arise in a MATLAB program, the code may issue
% an error or a warning. Custom errors can be implemented using the ERROR
% function. Best practice here is to use an error identifier as part of the
% custom error, to enable users to diagnose and debug problems more
% readily. The error identifier is a string which should contain a colon (:),
% and is the first input argument to the error function. For example, an
% error identifier might be 'fitQuadModel:EmptyMatrix'.y = MedData.Weight;
[Coeffs, fh] = fitQuadModel( [1;2], y, true);

