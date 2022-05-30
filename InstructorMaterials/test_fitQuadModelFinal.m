function tests = test_fitQuadModelFinal
    %TEST_FITQUADMODEL Main test function for the algorithm implemented in
    % fitQuadModel.
    
    % Test array constructed from local functions in this file.
    tests = functiontests( localfunctions() );
end

function setupOnce(testCase)
    addpath('./Test_Data')
    testCase.TestData = load('fitQuadModel_TestData.mat');
    testCase.TestData.currentRNG = rng;
end

function test_nargin(testCase)
    verifyError(testCase, @() fitQuadModelFinal(),'MATLAB:narginchk:notEnoughInputs')
    verifyError(testCase, @() fitQuadModelFinal(0), 'MATLAB:narginchk:notEnoughInputs')
    verifyError(testCase, @() fitQuadModelFinal(1, 2, 3, 4), 'MATLAB:TooManyInputs')
end

function test_invalidInputs(testCase)

    rng('default') % For reproducibility of tests.
    
    % the first input argument, X, is a real, 2D, nonempty double matrix with no infinite values;
    verifyError(testCase, @() fitQuadModelFinal(rand(10,0), rand(10,1)), ...
        'MATLAB:fitQuadModelFinal:expectedNonempty') % rand(10,0) gives 10x0 empty matrix
    verifyError(testCase, @() fitQuadModelFinal(Inf(10, 1), rand(10, 1)), ...
     'fitQuadModelFinal:expectedNoninfinite')

    % the second input argument, y, is a real, nonempty column vector of type double with no infinite values;
    verifyError(testCase, @() fitQuadModelFinal(rand(10, 1), Inf(10, 1)), ...
        'fitQuadModelFinal:expectedNoninfinite')

    % the third input argument, showplot, is a logical scalar value;
    verifyError(testCase, @() fitQuadModelFinal(rand(3,2), rand(3,1), true(1,2)), ...
        'MATLAB:fitQuadModelFinal:expectedScalar')

    % X has at least three rows and at most two columns;
    verifyError(testCase, @() fitQuadModelFinal(rand(2,2), rand(2,1)), ...
     'fitQuadModelFinal:XTooSmall')
    verifyError(testCase, @() fitQuadModelFinal(rand(3,4), rand(3,1)), ...
     'fitQuadModelFinal:TooManyXCols')
    % the number of rows of X and y coincide.
    verifyError(testCase, @() fitQuadModelFinal(rand(3,2), rand(2,1)), ...
        'fitQuadModelFinal:DimMismatch')
end

function test_validInputs(testCase)
    rng('default') % For reproducibility of test results.
    verifyInstanceOf(testCase, fitQuadModelFinal(rand(30,1), rand(30,1)), 'double')
    verifyInstanceOf(testCase, fitQuadModelFinal(rand(50,2), rand(50,1)), 'double')
    
    c = fitQuadModelFinal(rand(100,1), rand(100,1));
    verifySize(testCase, c, [3, 1])
    c = fitQuadModelFinal(rand(200,2), rand(200,1));
    verifySize(testCase, c, [6, 1])
end

function test_basicFit(testCase)
    
    % Test the algorithm on data for which we know the exact solution.
    x = testCase.TestData.X1;
    y = testCase.TestData.y1;
    cExpected = testCase.TestData.c1;
    cActual = fitQuadModelFinal(x, y);
    verifyEqual(testCase, cActual, cExpected, 'AbsTol', 1e-10)
    
    x = testCase.TestData.X2;
    y = testCase.TestData.y2;
    cExpected = testCase.TestData.c2;
    cActual = fitQuadModelFinal(x, y);
    verifyEqual(testCase, cActual, cExpected, 'AbsTol', 1e-10)
    
    % Test the function against another solution method (LINSOLVE).
    rng('default')
    x1 = rand(500, 1); x2 = rand(500, 1);
    y = rand(500, 1);
    A = [ones(size(x1)), x1, x2, x1.^2, x2.^2, x1.*x2];
    c_linsolve = linsolve(A, y);
    cActual = fitQuadModelFinal([x1, x2], y);
    verifyEqual(testCase, cActual, c_linsolve, 'AbsTol', 1e-10)
    
    % Test the function against another solution method (POLYFIT).
    rng('default')
    x = rand(500, 1);
    y = 15 + 4*x - 7*x.^2 + randn(size(x));
    c_polyfit = polyfit(x, y, 2);
    c_polyfit = flipud( c_polyfit.' );
    cActual = fitQuadModelFinal(x, y);
    verifyEqual(testCase, cActual, c_polyfit, 'AbsTol', 1e-10)
    
    
end % test_basicFit

function test_allNaNs(testCase)
    rng('default') % Reproducibility.
    x = rand(10, 1);
    y = NaN(10, 1);
    verifyError(testCase, @() fitQuadModelFinal(x, y), 'fitQuadModelFinal:AllNaNs')
end


function teardownOnce(testCase)
    % Remove the test directory from the path.
    rmpath('./Test_Data')
    % Restore the random number generator settings.
    s = testCase.TestData.currentRNG;
    rng(s)
end