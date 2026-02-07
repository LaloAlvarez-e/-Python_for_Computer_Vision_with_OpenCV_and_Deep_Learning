# Troubleshooting Guide for Environment Setup

## Problem: Build Errors with Old Package Versions

### Issue
The original `cvcourse_windows.txt` contains package versions from 2018 that are incompatible with modern Python (3.10+).

### Solutions

#### Option 1: Use Updated Requirements (Recommended)
The `cvcourse_windows.txt` has been updated with modern compatible versions:
```powershell
python setup_env.py Section_2
```

#### Option 2: Use Legacy Requirements with Older Python
If you need the exact original versions, use Python 3.6-3.8:
```powershell
# Install Python 3.8 from python.org
# Then create environment with:
python setup_env.py Section_2 requirements_legacy.txt
```

#### Option 3: Start with Minimal Requirements
Install only the core packages first:
```powershell
python setup_env.py Section_2 requirements_minimal.txt
```
Then install additional packages as needed:
```powershell
.\Section_2\cvcourse_env\Scripts\activate
pip install tensorflow keras
```

#### Option 4: Manual Installation
If automated setup fails, do it manually:
```powershell
# Create environment
python -m venv .\Section_2\cvcourse_env

# Activate it
.\Section_2\cvcourse_env\Scripts\Activate.ps1

# Upgrade pip
python -m pip install --upgrade pip

# Install packages one by one (troubleshoot as you go)
pip install numpy
pip install opencv-python opencv-contrib-python
pip install matplotlib
pip install scikit-learn
pip install jupyter notebook
pip install tensorflow keras
```

## Common Errors

### Error: "SafeConfigParser" AttributeError
**Cause**: Old matplotlib version incompatible with Python 3.12+
**Solution**: Use updated requirements or Python 3.8-3.11

### Error: "subprocess-exited-with-error"
**Cause**: Package build failure (usually due to version incompatibility)
**Solution**: 
1. Use `requirements_minimal.txt` first
2. Install problematic packages individually with updated versions
3. Skip optional packages (like jupyterlab) if they cause issues

### Error: PowerShell Execution Policy
**Cause**: Scripts are blocked by Windows security
**Solution**:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Package Version Notes

### Original vs Updated Versions

| Package | Original (2018) | Updated (2024+) | Notes |
|---------|----------------|-----------------|-------|
| Python | 3.6.6 | 3.8-3.12 | Use 3.8-3.11 for best compatibility |
| TensorFlow | 1.10.0 | 2.10+ | Major API changes, code may need updates |
| Keras | 2.2.2 | 2.10+ | Now integrated with TensorFlow |
| NumPy | 1.15.1 | 1.21+ | Better performance |
| OpenCV | 3.4.2 | 4.5+ | New features, mostly backward compatible |
| Matplotlib | 2.2.3 | 3.5+ | Won't build on Python 3.12+ |

## Recommended Approach

1. **Start fresh**: Delete `.\Section_2\cvcourse_env` if it exists
2. **Use updated requirements**: Run `python setup_env.py Section_2`
3. **Test imports**: After installation, test with:
   ```powershell
   .\Section_2\cvcourse_env\Scripts\activate
   python -c "import cv2, numpy, sklearn; print('Success!')"
   ```
4. **Update course code if needed**: Some TensorFlow 1.x code may need updates for TensorFlow 2.x

## Quick Commands

### Delete and Recreate Environment
```powershell
# Remove old environment
Remove-Item -Recurse -Force .\Section_2\cvcourse_env

# Create new one
python setup_env.py Section_2
```

### Check Python Version
```powershell
python --version
```

### Install Single Package
```powershell
.\Section_2\cvcourse_env\Scripts\activate
pip install package-name
```

### List Installed Packages
```powershell
.\Section_2\cvcourse_env\Scripts\activate
pip list
```
