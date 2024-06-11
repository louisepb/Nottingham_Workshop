%% Memory Anatomy
% On a Windows system, the MEMORY command can be used to obtain available
% memory information. Calling the MEMORY function with two outputs produces
% two structures which contain user and system information, respectively.
[user, sys] = memory;
disp(user)
disp(sys)

%% Copy-on-Write Behaviour
% When assigning one variable to another, MATLAB does not create a copy of
% that variable until it is necessary. Instead, it creates a reference.
% A copy is made only when code modifies one or more values in the
% reference variable. This behaviour is known as copy-on-write behaviour
% and is designed to avoid making copies of large arrays unless it is
% necessary. For example:
clear
m = memory;
disp('Memory available (GB):')
disp(m.MemAvailableAllArrays/1073741824)

A = rand(6e3);
m = memory;
disp('Memory available after allocating A (GB):')
disp(m.MemAvailableAllArrays/1073741824)

B = A; 
% This is only a reference at the moment, so available memory should 
% remain constant.
m = memory;
disp('Memory available after B=A (GB):')
disp(m.MemAvailableAllArrays/1073741824)

B(1, 1) = 0; 
% Now that we have made a change, copy-on-write should kick-in.
m = memory;
disp('Memory available after changing B(GB):')
disp(m.MemAvailableAllArrays/1073741824)