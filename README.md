# MRI Processing Tools in MATLAB

This repository contains a collection of MATLAB functions designed to simplify common tasks when working with MRI data. These tools were developed by **Harrison Brammell** while working at the Auburn University MRI Research Center under the guidance of **Dr. Adil Bashir**.

---

![Profile views](https://views.igorkowalczyk.dev/api/badge/harrisoncbrammell?style=classic)

## Functions

---

### Image Tools (`image-tools/`)

#### `nii4to3d.m`

Splits a 3D or 4D NIfTI file into a series of 3D NIfTI files, one per slice along the third dimension.

**Usage:**
```matlab
nii3to4d(imagein)
```

**Parameters:**
* `imagein`: The input 3D or 4D NIfTI image data.

**Details:**
* Determines image size with `size(imagein)`.
* Creates a new directory `./3d_niis/`.
* Iterates through the third dimension (Z-slices) and saves each slice as `slice_i.nii` using `niftiwrite`.

---

#### `dicomto4d.m`

Searches through a directory for DICOM files and returns a 4D array of size [x, y, z, # of DICOMS].

**Usage:**
```matlab
data = dicomto4d(path)
```

**Parameters:**
* `path`: Directory path containing DICOM files.

**Returns:**
* `data`: 4D array containing all DICOM images.

**Details:**
* Uses natural sorting to order DICOM files numerically (1.dcm, 2.dcm, etc.).
* Creates a 4D array based on the size of the first DICOM file.
* Files must be numbered in the order they should appear in the fourth dimension.
* Designed for DICOM files as produced by Siemens MRI scanners.

---

#### `normClamp.m`

Normalizes and clamps a 2D image to specified intensity ranges.

**Usage:**
```matlab
normImg = normClamp(image, low, high)
```

**Parameters:**
* `image`: Input 2D image.
* `low`: Lower clamp value.
* `high`: Upper clamp value.

**Returns:**
* `normImg`: Normalized and clamped image with values between 0 and 1.

**Details:**
* Converts image to double precision.
* Clamps values below `low` to `low` and above `high` (or infinite) to `high`.
* Normalizes the result to the range [0, 1].

---

### qMRLab Tools (`qMRLab-tools/`)

These tools require [qMRLab v2.4.2](https://github.com/harrisoncbrammell/qMRLab) - Harrison's fork with specific modifications for the Auburn University MRI Research Center.

#### `process_nifti_exp_mono_t2.m`

Processes a NIfTI file using the mono_T2 model with exponential fitting. Utilizes [qMRLab](https://github.com/qMRLab/qMRLab) **v2.4.2**.

**Prerequisites:**
* Must be in the working directory of **qMRLab v2.4.2** (only tested version).
* Requires the **MATLAB Parallel Computing Toolbox**.

**Usage:**
```matlab
process_nifti_exp_mono_t2(inputnii, inputmask, outputpath, et, t2, m0, snr)
```

**Parameters:**
* `inputnii`: Path to the input NIfTI file.
* `inputmask` (optional): Path to the NIfTI mask file.
* `outputpath` (optional): Directory path to save the output. Defaults to `pwd` if not specified.
* `et` (optional): Echo times as a column vector. Defaults to `transpose([10:10:70])`.
* `t2`, `m0`, `snr` (optional): Additional simulation parameters.

**Details:**
* **Validation**: Checks if `inputnii` exists.
* **qMRLab Setup**: Runs `startup.m` and initializes the `mono_t2` model.
* **Data Processing**: Uses exponential fitting and parallel processing.
* **Output**: Saves fitted results and generates simulation plots (single voxel curve and sensitivity analysis).

---

#### `process_nifti_lin_mono_t2.m`

Processes a NIfTI file using the mono_T2 model with linear fitting. Similar to the exponential version but uses linear fitting approach.

**Prerequisites:**
* Must be in the working directory of **qMRLab v2.4.2** (only tested version).
* Requires the **MATLAB Parallel Computing Toolbox**.

**Usage:**
```matlab
process_nifti_lin_mono_t2(inputnii, inputmask, outputpath, et, t2, m0, snr)
```

**Parameters:**
* Same as `process_nifti_exp_mono_t2.m`

**Details:**
* Sets `Model.options.FitType = 'Linear'` for linear fitting approach.
* Otherwise identical to the exponential version in terms of workflow and outputs.

---

### Deprecated Functions (`deprecated/`)

#### `dicom2image.m`

Converts a DICOM file and returns an image object.

**Status:** Work in progress / Untested

**Usage:**
```matlab
[image] = dicom2image(filename, color)
```

**Parameters:**
* `filename`: Path to the DICOM file.
* `color` (optional): Colormap to apply to the image (e.g., `'gray'`, `'jet'`). Defaults to `'gray'`.

**Returns:**
* `image`: Handle to a hidden figure containing the displayed DICOM data.

**Details:**
* Reads the DICOM file using `dicomread`.
* Creates a hidden figure and displays the image with the specified colormap.
* Includes a colorbar for reference.

---

## Disclaimer

These tools are provided as-is. Please ensure you have the necessary dependencies (e.g., [qMRLab v2.4.2](https://github.com/qMRLab/qMRLab/releases/tag/v2.4.2)) installed and correctly configured for successful execution.
