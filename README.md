# Fractional Brownian Motion (FBM) Generator

This code generates patterns using the fractional Brownian motion (FBM), a mathematical technique used to create fractal-like images. The code is inspired in the well-documented posts from M. McGuire [1], I. Quilez [2], and P. Gonzalez-Vivo & J. Lowe [3].

The code was used to create the cover of a PhD thesis titled ```Development of a wide-spectrum thermochemical code with application to planar reaction and non-reacting shocks```.


The process to generate the cover was as follows:
1. Get an image that mimics turbulence using the script.
2. Vectorize the image using SVGStorm [4]. This will homogenize the image without the need to generate a large image.
3. Post-process the image using Inkscape [5].

# Preview

<p align="left">
    <img src="https://github.com/AlbertoCuadra/fbm/blob/master/examples/phd_cover.svg" width="1400">
</p>
<p align="left">
    <img src="https://github.com/AlbertoCuadra/fbm/blob/master/examples/parula.svg" width="400">
    <img src="https://github.com/AlbertoCuadra/fbm/blob/master/examples/bone.svg" width="400">
    <img src="https://github.com/AlbertoCuadra/fbm/blob/master/examples/summer.svg" width="400">
    <img src="https://github.com/AlbertoCuadra/fbm/blob/master/examples/winter.svg" width="400">
</p>

## Usage
The function can be called with optional name-pair arguments, such as:

* zoom (float): Zoom factor of the image.
* octaves (float): Number of octaves.
* resolution (float): Resolution of the image (width, height) in pixels.
* palette (float): Colormap of the image, e.g., ```summer``` or ```winter```.
* ntimes (float): Number of images to generate.
* velocity (float): Velocity of the pattern.
* direction (float): Direction of the pattern (x, y).

## Examples:

```matlab
fbm()
fbm('resolution', [640, 360])
fbm('resolution', [640, 360], 'zoom', 0.5)
fbm('resolution', [640, 360], 'zoom', 0.5, 'octaves', 4)
fbm('resolution', [640, 360], 'zoom', 0.5, 'octaves', 4, 'ntimes', 1000)
fbm('resolution', [640, 360], 'zoom', 0.5, 'octaves', 4, 'ntimes', 1000, 'velocity', 5)
fbm('resolution', [640, 360], 'zoom', 0.5, 'octaves', 4, 'ntimes', 1000, 'velocity', 5, 'palette', 'winter')
```

## References
[1] M. McGuire: https://www.shadertoy.com/view/4dS3Wd
[2] I. Quilez: https://iquilezles.org/articles/fbm
[3] P. Gonzalez-Vivo & J. Lowe: https://thebookofshaders.com/13
[4] SVGStorm: https://svgstorm.com/app
[5] Inkscape: https://inkscape.org