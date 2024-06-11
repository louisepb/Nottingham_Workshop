function [ y ] = foo( x )
%foo Demonstrate function workspaces
a = sin(x);
x = x+1;
b = sin(x);
y = a*b;
end

