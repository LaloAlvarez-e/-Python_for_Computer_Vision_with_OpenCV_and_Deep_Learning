# Quick Setup Guide - Handling Windows Long Path Issue

## 🚨 The Problem
You're seeing this error:
```
OSError: [Errno 2] No such file or directory: '...very long path...'
HINT: This error might have occurred since this system does not have Windows Long Path support enabled.
```

## ✅ Quick Solutions (Choose One)

### Option 1: Use Core Requirements (FASTEST - No Admin Required)
Skip JupyterLab to avoid the issue:
```powershell
python setup_env.py .\Section_2\ requirements_core.txt
```

**Includes:**
- ✅ NumPy, OpenCV, Scikit-learn, Matplotlib, Pillow
- ✅ Jupyter Notebook (basic)
- ❌ JupyterLab (this causes the long path issue)

### Option 2: Enable Long Paths (BEST - Requires Admin)
**Steps:**
1. Right-click PowerShell and select **"Run as Administrator"**
2. Navigate to your project folder:
   ```powershell
   cd C:\git\-Python_for_Computer_Vision_with_OpenCV_and_Deep_Learning
   ```
3. Run the enable script:
   ```powershell
   .\enable_long_paths.ps1
   ```
4. **Restart your computer** when prompted
5. After restart, run:
   ```powershell
   python setup_env.py .\Section_2\ requirements_minimal.txt
   ```

### Option 3: Use Shorter Path (Quick Fix)
Move to a shorter directory path:
```powershell
# Create a shorter path
mkdir C:\CV
cd C:\CV

# Copy your files
copy C:\git\-Python_for_Computer_Vision_with_OpenCV_and_Deep_Learning\*.* .

# Run setup with shorter path
python setup_env.py Section_2 requirements_minimal.txt
```

### Option 4: Manual Registry Edit (If Script Fails)
1. Press `Win + R`
2. Type `regedit` and press Enter
3. Navigate to: `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem`
4. Right-click → New → DWORD (32-bit) Value
5. Name it: `LongPathsEnabled`
6. Double-click and set value to: `1`
7. Click OK
8. **Restart your computer**

## 📋 Comparison

| Option | Speed | Admin Required | Restart Required | Full Features |
|--------|-------|----------------|------------------|---------------|
| Core Requirements | ⚡ Fastest | ❌ No | ❌ No | ⚠️ Basic Jupyter only |
| Enable Long Paths | ⏱️ Medium | ✅ Yes | ✅ Yes | ✅ All features |
| Shorter Path | ⚡ Fast | ❌ No | ❌ No | ✅ All features |
| Manual Registry | ⏱️ Slow | ✅ Yes | ✅ Yes | ✅ All features |

## 🎯 Recommended Approach

**For Quick Testing:**
```powershell
python setup_env.py .\Section_2\ requirements_core.txt
```

**For Long-term Use:**
1. Run `.\enable_long_paths.ps1` as Administrator
2. Restart computer
3. Use full requirements

## 📦 Requirements Files Available

| File | Description | Long Path Safe? |
|------|-------------|-----------------|
| `requirements_core.txt` | No JupyterLab, just notebook | ✅ Yes |
| `requirements_minimal.txt` | Includes JupyterLab | ❌ Needs long paths |
| `cvcourse_windows.txt` | Full modern packages | ❌ Needs long paths |
| `requirements_legacy.txt` | 2018 versions | ❌ Needs long paths |

## 🔄 After Enabling Long Paths

Test if it worked (after restart):
```powershell
# This should work now
python setup_env.py .\Section_2\ requirements_minimal.txt
```

## ❓ Need Help?

See `FIX_LONG_PATH.md` for detailed troubleshooting steps.
