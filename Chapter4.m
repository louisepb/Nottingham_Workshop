%% Best BMI Predictors
% Attempt to invoke the function 
predictorRankings = findBestPredictors();

% a = 10
%% Attempt to invoke the function with a try block
try
    predictorRankings = findBestPredictors();
catch MExc
    disp(MExc.message)
end
% a = 10

%% Run function with profiler
profile on
try
    predictorRankings = findBestPredictors();
catch MExc
    disp(MExc.message)
end
profile off
profile viewer

