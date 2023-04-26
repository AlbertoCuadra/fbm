function geom = geom_progression(x, n)
    % Generates the geometric progression of a value n times 
    %
    % Args: 
    %     x (float): Initial value
    %     n (float): Number of times to generate the progression
    %
    % Returns:
    %     geom (float): Geometric progression vector
    %
    % Examples:
    %     * geom_progression(2, 5)
    %     * geom_progression(0.5, 5)
    
    exponents = 0:n-1;

    if x > 1
        geom = x .* 2.^exponents;
    else
        geom = x ./ 2.^exponents;
    end

end