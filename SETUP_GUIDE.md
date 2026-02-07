# Environment Setup Scripts - User Guide

## Overview
All setup scripts now automatically **clean and recreate** the virtual environment every time you run them. This ensures a fresh installation without conflicts from previous attempts.

---

## 🔧 Available Scripts

### 1. **`setup_env.py`** (Cross-platform Python script)
**Usage:**
```powershell
# Create in current directory with default requirements
python setup_env.py

# Create in specific folder with default requirements
python setup_env.py Section_2

# Create in specific folder with custom requirements file
python setup_env.py Section_2 requirements_minimal.txt
python setup_env.py Section_3 requirements_legacy.txt
```

### 2. **`setup_env.ps1`** (PowerShell - Windows) ⭐ **NEW**
**Usage:**
```powershell
# Create in current directory with default requirements
.\setup_env.ps1

# Create in specific folder
.\setup_env.ps1 Section_2

# Create with custom requirements file
.\setup_env.ps1 Section_2 requirements_minimal.txt
```

### 3. **`setup_env.bat`** (Batch Script - Windows) ⭐ **NEW**
**Usage:**
```cmd
REM Create in current directory
setup_env.bat

REM Create in specific folder
setup_env.bat Section_2

REM Create with custom requirements file
setup_env.bat Section_2 requirements_minimal.txt
```

### 4. **`setup_env.sh`** (Bash/Linux/macOS/Git Bash)
**Usage:**
```bash
source setup_env.sh
source setup_env.sh Section_2
```

### 5. **`activate_env.ps1`** (PowerShell - Simpler version)
**Usage:**
```powershell
# Create in current directory
.\activate_env.ps1

# Create in specific folder
.\activate_env.ps1 Section_2
```

### 6. **`activate_env.bat`** (Batch Script - Simpler version)
**Usage:**
```cmd
activate_env.bat
activate_env.bat Section_2
```

---

## 📦 Available Requirements Files

| File | Description | Recommended For |
|------|-------------|-----------------|
| `requirements_minimal.txt` | Core packages only (NumPy, OpenCV, Scikit-learn, Jupyter) | **Quick start, testing** ✅ |
| `cvcourse_windows.txt` | Updated modern versions (TensorFlow 2.x, latest packages) | **Modern Python 3.8-3.12** ✅ |
| `requirements.txt` | Same as cvcourse_windows.txt | **Standard pip convention** |
| `requirements_legacy.txt` | Original 2018 versions | **Python 3.6-3.8 only** |

---

## ⚡ Quick Start Examples

### Example 1: Create environment for Section 2 with minimal packages
```powershell
python setup_env.py Section_2 requirements_minimal.txt
```

### Example 2: Create environment for Section 3 with all modern packages
```powershell
python setup_env.py Section_3
```

### Example 3: Create environment in current directory
```powershell
python setup_env.py
```

---

## 🔄 Auto-Cleanup Feature

**What it does:**
- Automatically deletes the existing virtual environment before creating a new one
- Retries multiple times if files are locked (Windows)
- Provides clear error messages if cleanup fails

**Why it's useful:**
- No need to manually delete old environments
- Prevents conflicts from previous installations
- Ensures consistent, reproducible environments
- Fixes corrupted installations automatically

**When it runs:**
Every time you execute any setup script, it will:
1. ✅ Check if environment exists
2. 🗑️ Delete it completely
3. ✨ Create a fresh new environment
4. 📦 Install all packages from scratch

---

## 🎯 Workflow for Different Sections

### Managing Multiple Section Environments

```powershell
# Section 1 - Minimal setup
python setup_env.py Section_1 requirements_minimal.txt

# Section 2 - Full computer vision
python setup_env.py Section_2

# Section 3 - Same as Section 2
python setup_env.py Section_3

# Section 4 - Custom requirements
python setup_env.py Section_4 my_custom_requirements.txt
```

### Folder Structure Created
```
Project/
├── Section_1/
│   └── cvcourse_env/         # Virtual environment
├── Section_2/
│   └── cvcourse_env/         # Virtual environment
├── Section_3/
│   └── cvcourse_env/         # Virtual environment
├── requirements_minimal.txt
├── cvcourse_windows.txt
└── setup_env.py
```

---

## 🚀 After Setup - How to Use

### Activate the Environment

**PowerShell:**
```powershell
.\Section_2\cvcourse_env\Scripts\Activate.ps1
```

**Command Prompt:**
```cmd
.\Section_2\cvcourse_env\Scripts\activate.bat
```

**Bash/Linux/macOS:**
```bash
source Section_2/cvcourse_env/bin/activate
```

### Verify Installation
```powershell
# Activate first, then:
python -c "import cv2, numpy, sklearn; print('✓ All packages loaded successfully!')"
```

### Deactivate
```powershell
deactivate
```

---

## 🛠️ Troubleshooting

### Issue: "Directory not empty" error during cleanup
**Solution:** Close all programs that might be using the environment:
- VS Code terminals
- Jupyter notebooks
- Python processes
- File Explorer windows

Then run the script again.

### Issue: PowerShell script won't run
**Solution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Issue: Package installation fails
**Solution 1:** Use minimal requirements first
```powershell
python setup_env.py Section_2 requirements_minimal.txt
```

**Solution 2:** Install packages individually after setup
```powershell
.\Section_2\cvcourse_env\Scripts\activate
pip install tensorflow keras
```

### Issue: Wrong Python version
Check your Python version:
```powershell
python --version
```
- Recommended: Python 3.8 - 3.11
- Minimum: Python 3.8
- Maximum tested: Python 3.12

---

## 📝 Tips & Best Practices

1. **Use folder names without spaces** (e.g., `Section_2` not `Section 2`)
2. **Run scripts from the project root directory**
3. **Always activate the environment before running Python code**
4. **Use minimal requirements for testing, full requirements for production**
5. **Each section can have its own independent environment**
6. **Re-run the setup script anytime to get a fresh environment**

---

## 🔑 Key Features Summary

✅ **Automatic cleanup** - No manual deletion needed  
✅ **Flexible folder structure** - Organize by section/project  
✅ **Multiple requirements files** - Choose what you need  
✅ **Cross-platform** - Windows, Linux, macOS support  
✅ **Error handling** - Clear messages and retry logic  
✅ **Fresh installs** - No conflicts or corruption  

---

## 📞 Need Help?

See `TROUBLESHOOTING.md` for detailed error solutions and common issues.
