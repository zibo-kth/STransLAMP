 function fcn = makefcn(a,b,c)
% This function returns a handle to a customized version of 'parabola'.
% a,b,c specifies the coefficients of the function.

fcn = @parabola; % Return handle to nested function

    function y = parabola(x)
        % This nested function can see the variables 'a','b', and 'c'
        y = a*x.^2 + b.*x + c;
    end

end