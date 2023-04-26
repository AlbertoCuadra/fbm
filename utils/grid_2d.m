function [X, Y] = grid_2d(resolution)
    % Generate a 2D grid with the given resolution (width and height) in pixels
    %
    % Args:
    %     resolution (float): Vector (x, y) with the width and height, respectively
    %
    % Returns:
    %     Tuple containing
    %
    %     * X (float): Grid points x-axis
    %     * Y (float): Grid points y-axis

    x = 0:1:resolution(1);
    y = 0:1:resolution(2);
    [X, Y] = meshgrid(x, y);
end