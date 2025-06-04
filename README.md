# MRI Processing Tools in MATLAB

This repository contains a collection of MATLAB functions designed to simplify common tasks when working with MRI data. These tools were developed by **Harrison Brammell** while working at the Auburn University MRI Research Center under the guidance of **Dr. Adil Bashir**.

---

![Profile views](https://views.igorkowalczyk.dev/api/badge/harrisoncbrammell?style=classic)

## Functions

### 1. `nii3to4d.m`

Splits a 3D or 4D NIfTI file into a series of 3D NIfTI files, one per slice along the third dimension.

#### Usage

```matlab
nii3to4d(imagein)
```

* `imagein`: The input 3D or 4D NIfTI image data.

#### Details

* Determines image size with `size(imagein)`.
* Creates a new directory `./3d_niis/`.
* Iterates through the third dimension (Z-slices):

  * For each `i`, extracts `imagein(:,:,i,:)`.
  * Saves the 3D slice as `slice_i.nii` in `./3d_niis/` using `niftiwrite`.

---

### 2. `process_nifti_exp_mono_t2.m`

Processes a NIfTI file using the mono\_T2 model with exponential fitting, and saves the result. Utilizes [qMRLab](https://github.com/qMRLab/qMRLab) **v2.4.2**.

#### Prerequisites

* Must be in the working directory of **qMRLab v2.4.2** (only tested version).
* Requires the **MATLAB Parallel Computing Toolbox**.

#### Usage

```matlab
process_nifti_exp_mono_t2(inputnii, inputmask, outputpath, et)
```

* `inputnii`: Path to the input NIfTI file.
* `inputmask` (optional): Path to the NIfTI mask file.
* `outputpath` (optional): Directory path to save the output. Defaults to `pwd` if not specified or invalid.
* `et` (optional): Echo times as a column vector. Defaults to `transpose([10:10:70])` if not provided.

#### Details

* **Validation**: Checks if `inputnii` exists using `~exist('inputnii','file')`.
* **qMRLab Setup**:

  * Runs `startup.m`.
  * Initializes the `mono_t2` model with echo times.
* **Data Loading**:

  * Loads input data using `load_nii_data` and stores in `data.SEdata`.
  * Optionally loads `inputmask` into `data.Mask`.
* **Processing**:

  * Fits the model using `ParFitData`.
  * Saves results using `FitResultsSave_nii`.

---

### 3. `dicom2image.m`

Converts a DICOM file and returns an image object.

**Status**: Work in progress / Untested

#### Usage

```matlab
[image] = dicom2image(filename, color)
```

* `filename`: Path to the DICOM file.
* `color` (optional): Colormap to apply to the image (e.g., `'gray'`, `'jet'`). Defaults to `'gray'`.

#### Returns

An image object, which is a handle to a hidden figure containing the displayed DICOM data.

#### Details

* Reads the DICOM file using `dicomread`.
* Creates a hidden figure using `figure('Visible', 'off')`.
* Displays the image data using `imagesc`, adds a colorbar, and applies the specified colormap.
* Returns the handle to the hidden figure.

---

## Disclaimer

These tools are provided as-is. Please ensure you have the necessary dependencies (e.g., [qMRLab v2.4.2](https://github.com/qMRLab/qMRLab/releases/tag/v2.4.2)) installed and correctly configured for successful execution.
