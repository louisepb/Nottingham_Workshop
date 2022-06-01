function tests = test_getwords_sol

    tests = functiontests( localfunctions() );

end

function setupOnce(testCase) %#ok<*DEFNU>
    addpath('Literature');
end

function test_IncorrectFilename(testCase) 
    verifyError(testCase,@()getwords('homero.txt'),'getwords:noFile');
end

function test_AllWords(testCase) 
    [W, ~] = getwords('sherlock_holmes.txt');
    actSolution = W;
    expSize = [207, 1];
    verifySize(testCase, actSolution, expSize);
end

function test_MaxFreq(testCase) 
    [~, T] = getwords('sherlock_holmes.txt');
    actSolution = max(T.Freq);
    expSolution = 10;
    verifyEqual(testCase, actSolution, expSolution);
end

function teardownOnce(testCase)
    % remove the Literature folder from the path
    rmpath('Literature');
end