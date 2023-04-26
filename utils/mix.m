function blended = mix(edge1, edge2, weight)
    % This function computes a value that is a linear interpolation between
    % two edges based on a weight. The weight is a value between 0 and 1
    %
    % Args:
    %     edge1 (float): Lower edge
    %     edge2 (float): Upper edge
    %     weight (float): Interpolation weight
    %
    % Returns:
    %     blended (float): Interpolated value

    blended = (1 - weight) .* edge1 + weight .* edge2;
end