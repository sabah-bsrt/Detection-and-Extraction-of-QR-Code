%% Step 1: Read and Display the Original Image

img = imread('https://digital-link.com/_ipx/s_728x440/images/2025/06/Hand-holding-a-beer-bottle-with-a-QR-code-label-in-front-of-store-shelves.png');

% Convert original image to grayscale if necessary
if size(img, 3) == 3
    gray = rgb2gray(img);
else
    gray = img;
end

% Display original and grayscale images
mainFig = figure('Name', 'Original, Grayscale, and Cropped');

subplot(1,3,1);
imshow(img);
title('Original Image');

subplot(1,3,2);
imshow(gray);
title('Grayscale');


%% Step 2: Edge Detection using Canny Operator

edges = edge(gray, 'Canny');

% Finds sharp transitions in intensity
% Important for detecting the boundaries of the QR code


%% Step 3: Dilate Edges to Connect Border Segments

se = strel('square', 3);

dilated = imdilate(edges, se);

% Morphological dilation thickens and connects border lines


%% Step 4: Fill Interior Holes

filled = imfill(dilated, 'holes');

% Fill holes inside detected regions
% This helps create solid candidate regions


%% Step 5: Remove Small Objects (Noise)

clean = bwareaopen(filled, 2000);


%% Step 6: Find Connected Components and Region Properties

cc = bwconncomp(clean);

stats = regionprops(cc, 'BoundingBox', 'Area', 'Extent');

% Extent = Area / BoundingBox Area
% A value closer to 1 indicates that the region fills its bounding box


%% Step 7: Select the Best QR Code Candidate

bestIdx = 0;
bestScore = 0;

for k = 1:length(stats)

    ext = stats(k).Extent;
    bbox = stats(k).BoundingBox;
    area = stats(k).Area;

    % Consider only sufficiently large regions
    if area < 5000
        continue;
    end

    % Score based on:
    % 1. Extent
    % 2. Closeness of the bounding box to a square

    score = ext / (1 + abs(bbox(3) - bbox(4)));

    if score > bestScore
        bestScore = score;
        bestIdx = k;
    end

end


%% Step 8: Crop the QR Code Region

if bestIdx > 0

    % Get the bounding box of the best candidate
    bbox = stats(bestIdx).BoundingBox;

    % Crop the QR region from the original image
    qrCropped = imcrop(img, bbox);

    % Display cropped QR code
    subplot(1,3,3);
    imshow(qrCropped);
    title('Cropped QR Code');


    %% Convert Cropped QR Image to Grayscale

    if size(qrCropped, 3) == 3
        qrGray = rgb2gray(qrCropped);
    else
        qrGray = qrCropped;
    end

else

    subplot(1,3,3);
    title('No QR Found');
    axis off;

    disp('No suitable QR Code region found.');

    return;

end


%% Step 9: Post-Processing of the Cropped QR Code

% Create a new figure for all image-processing results
figure('Name', 'QR Code Post-Processing');


%% 9.1 Gaussian Blur

gaussOut = imgaussfilt(qrGray, 1.2);

subplot(3,5,2);
imshow(gaussOut);
title('Gaussian \sigma = 1.2');


%% 9.2 Mean Filter 3x3

meanOut = imfilter(qrGray, fspecial('average', 3), 'replicate');

subplot(3,5,3);
imshow(meanOut);
title('Mean 3x3');


%% 9.3 Median Filter 3x3

medianOut = medfilt2(qrGray, [3 3]);

subplot(3,5,4);
imshow(medianOut);
title('Median 3x3');


%% 9.4 Average Filter 5x5

avgOut = imfilter(qrGray, ones(5)/25, 'replicate');

subplot(3,5,5);
imshow(avgOut);
title('Average 5x5');


%% 9.5 Otsu Thresholding

level = graythresh(qrGray);

binaryOut = imbinarize(qrGray, level);

subplot(3,5,6);
imshow(binaryOut);
title('Otsu Thresholding');


%% 9.6 Sharpening

sharpOut = imsharpen(qrGray, ...
    'Radius', 5, ...
    'Amount', 4);

subplot(3,5,7);
imshow(sharpOut);
title('Sharpened');


%% 9.7 Histogram Equalization

histeqOut = histeq(qrGray);

subplot(3,5,8);
imshow(histeqOut);
title('Histogram EQ');


%% 9.8 Affine Transformation

T = [ ...
    0.9*cosd(15), -0.9*sind(15), 0;
    0.2,           0.9*cosd(15), 0;
    0,             0,             1
    ];

tform = affine2d(T);

affineOut = imwarp( ...
    qrGray, ...
    tform, ...
    'OutputView', imref2d(size(qrGray)) ...
    );

subplot(3,5,9);
imshow(affineOut);
title('Affine');


%% 9.9 Laplacian High-Pass Filter

hpKernel = [ ...
    -1 -1 -1;
    -1  8 -1;
    -1 -1 -1
    ];

laplaceHP = imfilter( ...
    double(qrGray), ...
    hpKernel, ...
    'replicate' ...
    );

laplaceHP = mat2gray(laplaceHP);

subplot(3,5,10);
imshow(laplaceHP);
title('HPF: Laplacian');


%% 9.10 Difference of Gaussians (DoG)

sigma1 = 1;
sigma2 = 3;

g1 = imgaussfilt(qrGray, sigma1);
g2 = imgaussfilt(qrGray, sigma2);

dogHP = imsubtract(g1, g2);

dogHP = mat2gray(dogHP);

subplot(3,5,11);
imshow(dogHP);
title('HPF: DoG');


%% 9.11 Geometric Ripple Distortion

[rows, cols] = size(qrGray);

[X, Y] = meshgrid(1:cols, 1:rows);

amp = 10;
lambda = 40;
freq = 2*pi/lambda;

Xr = X + amp * sin(freq * Y);
Yr = Y;

rippleOut = uint8( ...
    interp2( ...
        double(qrGray), ...
        Xr, ...
        Yr, ...
        'linear', ...
        0 ...
        ) ...
    );

subplot(3,5,12);
imshow(rippleOut);
title('Ripple Distortion');


%% End of Program

disp('QR detection and image processing completed successfully.');