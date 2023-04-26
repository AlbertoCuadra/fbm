function h = hash(p)
    % Computes a hash value for 2D points (x, y) in the range [0, 1] using
    % the golden ratio
    %
    % Args:
    %     p (float): Matrix with points (x, y)
    %
    % Returns:
    %     h (float): Matrix with hash values
    
    golden_ratio = 1.6180339887;
    p = fract(p * golden_ratio);
    p = p * 95.0;
    h = fract(p(:, 1) .* p(:, 2));
end