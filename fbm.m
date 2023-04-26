function fbm(varargin)
    % Generates patterns using the fractional Brownian motion (FBM).
    %
    % The code was inspired in the well-documented posts from M.
    % McGuire [1] I. Quilez [2], and P. Gonzalez-Vivo & J. Lowe [3].
    %
    % This routine was used to create the cover of my PhD thesis:
    % " 
    %   Development of a wide-spectrum thermochemical code with application
    %   to planar reaction and non-reacting shocks
    % "
    %
    % The process to generate the cover was:
    %     1. Get an image that mimics turbulence using the script.
    %     2. Vectorize the image using SVGStorm [3]. This will homogenize the
    %        image without the need to generate a large image.
    %     3. Post-process the image using Inkscape [4].
    %
    % Optional name-pair Args:
    %     * zoom (float): Zoom factor of the image
    %     * octaves (float): Number of octaves
    %     * resolution (float): Resolution of the image (width, height) in pixels
    %     * palette (float): Colormap of the image
    %     * ntimes (float): Number of images to generate
    %     * velocity (float): Velocity of the pattern
    %     * direction (float): Direction of the pattern (x, y)
    %
    % References:
    %     * [1] M. McGuire: https://www.shadertoy.com/view/4dS3Wd
    %     * [2] I. Quilez: https://iquilezles.org/articles/fbm
    %     * [3] P. Gonzalez-Vivo & J. Lowe: https://thebookofshaders.com/13
    %     * [4] SVGStorm: https://svgstorm.com/app
    %     * [5] Inkscape: https://inkscape.org
    %
    % Examples:
    %     * fbm()
    %     * fbm('resolution', [640, 360])
    %     * fbm('resolution', [640, 360], 'zoom', 0.5)
    %     * fbm('resolution', [640, 360], 'zoom', 0.5, 'octaves', 4)
    %     * fbm('resolution', [640, 360], 'zoom', 0.5, 'octaves', 4, 'ntimes', 1000)
    %     * fbm('resolution', [640, 360], 'zoom', 0.5, 'octaves', 4, 'ntimes', 1000, 'velocity', 5)
    %     * fbm('resolution', [640, 360], 'zoom', 0.5, 'octaves', 4, 'ntimes', 1000, 'velocity', 5, 'palette', 'bone')

    % Default
    zoom = 0.7;
    octaves = 4;
    resolution = 0.5 * [640, 360];
    palette = get_palette(256);
    ntimes = 1000;
    velocity = 5;
    direction = [5, 1];

    % Unpack
    for i = 1:2:nargin

        switch lower(varargin{i})
            case 'zoom'
                zoom = varargin{i + 1};
            case 'octaves'
                octaves = varargin{i + 1};
            case 'resolution'
                resolution = varargin{i + 1};
            case 'palette'
                palette = varargin{i + 1};

                if ischar(palette)
                    palette = colormap(palette);
                end

            case {'ntimes', 'time', 't'}
                ntimes = varargin{i + 1};
            case 'velocity'
                velocity = varargin{i + 1};
            case 'direction'
                direction = varargin{i + 1};
        end

    end

    % Miscellaneous
    figure;

    % Generate grid
    [X, Y] = grid_2d(resolution);
    
    % Get geometric progression
    weights = geom_progression(0.5, octaves + 4);

    % This vector is used to control the rate at which the amplitude of
    % each octave decreases in the fractal sum used to generate the
    % fractional Brownian motion (FBM) pattern.
    factors = 2 + 0.01 * geom_progression(1.2, octaves + 4);

    % Generate pattern
    X = 1/zoom * (X - resolution(1)) / resolution(2);
    Y = 1/zoom * (Y - resolution(2)) / resolution(2);

    % Coordinates
    p = [X(:), Y(:)];
    
    for t = 1:ntimes
        % Get pattern
        pattern = turbulence(p, t, velocity, direction, octaves, weights, factors);
    
        % Reshape
        pattern = reshape(pattern, size(X));
    
        % Display pattern
        imshow(pattern, 'Colormap', palette);
    end

end

% SUB-PASS FUNCTIONS
function pattern = turbulence(p, t, velocity, direction, octaves, weights, factors)
    % Routine that generates a pattern based on a noise function
    %
    % Args:
    %     p (float): Matrix with the grid points
    %     t (float): Time unit
    %     velocity (float): Velocity
    %     weights (float): Weights
    %     factors (float): Factors
    %
    % Returns:
    %     pattern (float): Pattern
    
    % Normalize Velocity
    velocity = velocity * t * 1e-4;

    % Normalize direction
    direction = direction / max(direction);

    % Add bias to x-coordinate
    p(:, 1) = p(:, 1) + direction(1) * velocity * (4 + sin(velocity)) * 1e1;

    % Add bias to y-coordinate
    p(:, 2) = p(:, 2) + direction(2) * velocity * (-2 + sin(velocity)) * 1e1;

    % Generate noise
    o = 0.5 + 0.5 * get_fbm_2(p, velocity, octaves, weights, factors);

    % Pulsating effect
    o = o + 0.02*sin(0.1 * velocity * [5, 7] * 1e-2);

    % Generate fractal noise
    n = get_fbm_2(4 * o, 0.3 * velocity, octaves + 4, weights, factors);
    
    % Add noise
    p = 1 + 2* (p + n);
    
    % Generate fractal noises
    pattern = 0.5 + 0.5 * get_fbm(2 * p, 0.3 * velocity, octaves, weights, factors);
end

function f = get_fbm(p, t, octaves, weights, factors)
    % Computes the fractional Brownian motion (FBM) of a matrix of points
    %
    % Args:
    %     p (float): Matrix with points (x, y)
    %     t (float): Time unit
    %     octaves (float): Number of octaves
    %     weights (float): Weights
    %     factors (float): Factors
    %
    % Returns:
    %     f (float): FBM value

    % Definitions 
    A_rot = [cos(pi/5 + t), sin(pi/5 + t); -sin(pi/5 + t), cos(pi/5 + t)];

    % Initialization
    f = 0;
    
    % Loop
    for i = 1:octaves
        f = f + weights(i) * (2*noise(p) - 1);
        p = p * A_rot * factors(i);
    end

    % Return the fbm value
    f = f / sum(weights(1:octaves));
end

function value = noise(p)
    % Computes Perlin noise for the given points
    %
    % Args:
    %     x (float): Matrix with point (x, y) to compute noise
    %
    % Returns:
    %     value (float): Perlin noise value at the given points
    %
    % Note:
    %     The algorithm works by dividing the input point x into a 2D grid
    %     of unit squares. Each vertex of the grid is assigned a random gradient
    %     vector, which is then used to interpolate the noise value at the input
    %     point. The interpolation is done using a weighted average of the
    %     dot products between the gradient vectors and the vectors from the
    %     grid vertices to the input point x.
    %
    %     The `hash` and `mix` functions are used for the gradient vector
    %     and interpolation calculations, respectively.
    
    % Definitions
    f = fract(p);
    p = floor(p);
    
    % Get vertex of the square
    a = hash(p);
    b = hash(p + [1, 0]);
    c = hash(p + [0, 1]);
    d = hash(p + [1, 1]);
    
    % Get weights using Hermite interpolation
    f = f.^2 .* (3 - 2 * f);

    % Get noise
    value = mix(mix(a, b, f(:, 1)), mix(c, d, f(:, 1)), f(:, 2));
end

function f_vector = get_fbm_2(p, t, octaves, weights, factors)
    % Computes the fractal brownian motion (FBM) of two points and returns
    % them in a vector
    %
    % Args:
    %     p (float): Matrix with the starting points (x, y)
    %     octaves (float): Number of octaves
    %     t (float): Time unit
    %     weights (float): Weights
    %     factors (float): Factors
    %
    % Returns:
    %     f_vector (float): FBM values for two points returned in a vector

    % Get offset
    if octaves > 4
        a = [1, 1] + t;
        b = [6.2, 6.2] + t;
    else
        a = [9.2, 9.2] + t;
        b = [5.7, 5.7] + t;
    end

    f_vector = [get_fbm(p + a, t, octaves, weights, factors),...
                get_fbm(p + b, t, octaves, weights, factors)];
end