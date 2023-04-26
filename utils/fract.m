function value = fract(x)
    % This function calculates the fractional part of a number
    % 
    % Args: 
    %     x (float): float numbers
    %
    % Returns:
    %     value (float): fractional part of x
    
    value = x - floor(x);
end