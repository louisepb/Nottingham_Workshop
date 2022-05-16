function setupPath()
% Set up the MATLAB path for the course.

% We want all folders under the class folder to be on the path for the course.
dirNames = {'ArmsLegs', 'Exercises', 'InstructorMaterials', ...
            'Reference', 'work', 'StudentMaterials'};
for k = 1:numel(dirNames)
    addpath(genpath(dirNames{k}));
end

% We don't want the test data folder on the path yet.
warning('off', 'MATLAB:rmpath:DirNotFound')
rmpath('Test_Data')
warning('on', 'MATLAB:rmpath:DirNotFound')

end % setupPath