# QR Code Detection and Extraction

A MATLAB-based classical computer vision project for detecting, extracting, and enhancing QR codes from natural images without using machine learning.

## Overview

This project implements a classical image processing pipeline to automatically locate potential QR code regions in photographic images, crop the detected region, and apply a series of image enhancement and filtering techniques.

The project was developed as part of **ENGI 9804 – Industrial Machine Vision** and focuses on traditional computer vision methods rather than machine learning.

## Approach

The QR detection and enhancement pipeline consists of the following stages:

1. **Grayscale Conversion**

   * Converts the input RGB image to grayscale.
   * Simplifies the image representation for subsequent intensity-based processing.

2. **Canny Edge Detection**

   * Detects intensity transitions and highlights potential QR code boundaries.

3. **Morphological Processing**

   * Uses dilation to connect fragmented edges.
   * Performs hole filling to create closed candidate regions.

4. **Connected Component Analysis**

   * Removes small irrelevant regions using area-based filtering.
   * Extracts geometric properties such as:

     * Bounding box
     * Area
     * Extent

5. **QR Candidate Selection**

   * Candidate regions are evaluated using a scoring function based on their extent and rectangular geometry.
   * The highest-scoring region is selected as the potential QR code.

6. **QR Region Cropping**

   * The bounding box of the selected candidate is used to extract the QR code from the original image.

7. **Image Enhancement and Filtering**

   The extracted QR region is processed using several techniques:

   * Gaussian filtering
   * Mean filtering
   * Median filtering
   * Otsu thresholding
   * Image sharpening
   * Histogram equalization
   * Laplacian high-pass filtering
   * Difference of Gaussians (DoG)
   * Affine transformation
   * Geometric ripple distortion

8. **Visualization**

   * The output of each processing stage is displayed for comparison and evaluation.

## Technologies

* **MATLAB**
* Image Processing Toolbox
* Classical Computer Vision / Image Processing
* Morphological Image Processing
* Connected Component Analysis
* Spatial and Frequency-Domain Filtering

## Input

The program reads a photographic image containing a QR code:

```matlab
img = imread('QRcode3.jpg');
```

The input image is then processed through the detection and enhancement pipeline.

Below, there are 2 of them which were successful in the result:

1.  https://cdn.sanity.io/images/0aocp9sp/production/10981fd093c4ef1ae92644ec2b465505cf30f7ee-1024x576.jpg?w=3840&auto=format&q=65&fit=max
  
2.  https://digital-link.com/_ipx/s_728x440/images/2025/06/Hand-holding-a-beer-bottle-with-a-QR-code-label-in-front-of-store-shelves.png

However, this one was not completely successful:
  https://maplejet.com/wp-content/uploads/2024/09/WhatsApp-Image-2024-09-06-at-10.12.48_29e4844b-edited.jpg

## Example Processing Pipeline

```text
Original Image
      ↓
Grayscale Conversion
      ↓
Canny Edge Detection
      ↓
Morphological Dilation
      ↓
Hole Filling
      ↓
Area Filtering
      ↓
Connected Component Analysis
      ↓
Candidate Scoring
      ↓
QR Region Cropping
      ↓
Grayscale QR Region
      ↓
 ┌───────────────────────────────┐
 │ Gaussian Filter               │
 │ Mean Filter                   │
 │ Median Filter                 │
 │ Otsu Thresholding             │
 │ Sharpening                    │
 │ Histogram Equalization        │
 │ Laplacian High-Pass           │
 │ Difference of Gaussians       │
 │ Affine Transformation         │
 │ Ripple Distortion             │
 └───────────────────────────────┘
      ↓
Visualization & Comparison
```

## Results

The system successfully detected and cropped QR codes in several test images, particularly under relatively clean and controlled conditions.

The applied filters provide different types of enhancement:

* **Gaussian, mean, and median filters** reduce image noise.
* **Sharpening** enhances local edges and details.
* **Otsu thresholding** converts the QR region into a binary representation.
* **Histogram equalization** improves global contrast.
* **Laplacian filtering** emphasizes high-frequency structures and edges.
* **Difference of Gaussians (DoG)** highlights structural boundaries.
* **Affine transformation** introduces geometric transformations such as rotation, scaling, and shearing.
* **Ripple distortion** is used to test robustness against nonlinear geometric deformation.

## Limitations

The detection method performs well when the QR code has sufficient contrast and a relatively clean background.

However, detection may fail when:

* The background is complex.
* The contrast between the QR code and its background is insufficient.
* The QR code is partially distorted.
* Lighting conditions are non-ideal.
* The QR code does not produce a sufficiently strong candidate region.

For example, a test case with a green background resulted in an incorrect crop because of insufficient contrast and possible geometric distortion.

## Future Improvements

Potential improvements identified in the project include:

* Adaptive thresholding
* Improved contrast enhancement
* Pre-processing for complex backgrounds
* A more robust QR candidate scoring mechanism
* Additional region properties such as eccentricity and solidity
* Perspective correction for distorted QR codes

## Project Context

This project demonstrates how classical image processing techniques can be combined to detect structured visual patterns such as QR codes without relying on machine learning.

It highlights the use of edge detection, morphological operations, connected component analysis, spatial filtering, frequency-domain enhancement, and geometric transformations in a practical machine vision application.
