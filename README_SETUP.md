# README - Python Environment Setup for Computer Vision Course

## 📦 Project Files Overview

### Environment Setup Scripts
- **`setup_env.py`** - Universal Python script (all platforms)
- **`setup_env.ps1`** - PowerShell version (Windows)
- **`setup_env.bat`** - Batch script (Windows)
- **`setup_env.sh`** - Bash script (Linux/Mac/Git Bash)
- **`activate_env.ps1`** - Simpler PowerShell version
- **`activate_env.bat`** - Simpler batch version

### Requirements Files
- **`requirements_core.txt`** ⭐ **Recommended** - No long path issues
- **`requirements_minimal.txt`** - Core packages + JupyterLab (needs long path fix)
- **`cvcourse_windows.txt`** - Full modern packages
- **`requirements.txt`** - Same as cvcourse_windows.txt
- **`requirements_legacy.txt`** - Original 2018 versions (Python 3.6-3.8)

### Documentation
- **`QUICK_FIX.md`** ⭐ **Start Here** - Solutions for Windows long path issue
- **`FIX_LONG_PATH.md`** - Detailed long path troubleshooting
- **`SETUP_GUIDE.md`** - Complete user guide
- **`SCRIPTS_REFERENCE.md`** - Script comparison and usage
- **`TROUBLESHOOTING.md`** - General troubleshooting

### Utilities
- **`enable_long_paths.ps1`** - Run as Admin to enable Windows long paths
- **`cvcourse_windows.yml`** - Original Conda environment file

---

## 🚀 Quick Start (Windows)

### If You're Seeing Long Path Errors:
```powershell
# Use this command (works immediately, no admin needed)
python setup_env.py .\Section_2\ requirements_core.txt
```

### For Best Long-term Setup:
1. **Run PowerShell as Administrator**
2. Navigate to project folder:
   ```powershell
   cd C:\git\-Python_for_Computer_Vision_with_OpenCV_and_Deep_Learning
   ```
3. Enable long paths:
   ```powershell
   .\enable_long_paths.ps1
   ```
4. **Restart your computer**
5. Run full setup:
   ```powershell
   python setup_env.py .\Section_2\ requirements_minimal.txt
   ```

---

## 📖 Usage Examples

### Create Environment for Section 2
```powershell
# Core packages (safest)
python setup_env.py Section_2 requirements_core.txt

# Full packages (needs long path enabled)
python setup_env.py Section_2 requirements_minimal.txt

# PowerShell version
.\setup_env.ps1 Section_2 requirements_core.txt

# Batch version
setup_env.bat Section_2 requirements_core.txt
```

### Create Multiple Section Environments
```powershell
python setup_env.py Section_1 requirements_core.txt
python setup_env.py Section_2 requirements_core.txt
python setup_env.py Section_3 requirements_core.txt
```

### Activate an Environment
```powershell
# Windows PowerShell
.\Section_2\cvcourse_env\Scripts\Activate.ps1

# Windows CMD
.\Section_2\cvcourse_env\Scripts\activate.bat

# Linux/Mac
source Section_2/cvcourse_env/bin/activate
```

### Deactivate
```powershell
deactivate
```

---

## 🔑 Key Features

✅ **Auto-cleanup** - Removes old environment before creating new one  
✅ **Retry logic** - Handles locked files (3 attempts)  
✅ **Multiple sections** - Create separate environments per section  
✅ **Flexible requirements** - Choose package set that works for you  
✅ **Cross-platform** - Scripts for Windows, Linux, Mac  
✅ **No conflicts** - Fresh install every time  

---

## 📋 What's Included in Each Requirements File?

### `requirements_core.txt` (Recommended)
```
✅ NumPy - Scientific computing
✅ OpenCV - Computer vision (main + contrib)
✅ Scikit-learn - Machine learning
✅ Matplotlib - Plotting
✅ Pillow - Image processing
✅ Jupyter Notebook - Interactive notebooks
❌ JupyterLab - Excluded (causes long path issues)
❌ TensorFlow/Keras - Optional, add later if needed
```

### `requirements_minimal.txt`
```
Everything in core PLUS:
✅ JupyterLab - Full Jupyter environment (needs long path fix)
❌ TensorFlow/Keras - Optional
```

### `cvcourse_windows.txt` (Full)
```
Everything in minimal PLUS:
✅ TensorFlow 2.x - Deep learning
✅ Keras - Neural networks
✅ All Jupyter components
```

---

## 🆘 Common Issues & Solutions

### Issue: Long Path Error
**Solution:** Use `requirements_core.txt` or enable long paths (see QUICK_FIX.md)

### Issue: "Access Denied" when enabling long paths
**Solution:** Must run PowerShell as Administrator

### Issue: Packages fail to install
**Solution:** Try `requirements_core.txt` first, then add packages individually

### Issue: Script won't run in PowerShell
**Solution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Issue: Environment already exists error
**Solution:** Scripts auto-cleanup, but you can manually delete:
```powershell
Remove-Item -Recurse -Force .\Section_2\cvcourse_env
```

---

## 🎓 Workflow Recommendation

### For Students Following the Course:
1. Use `requirements_core.txt` for quick setup
2. Each section gets its own environment
3. Add TensorFlow/Keras when you reach those sections:
   ```powershell
   .\Section_2\cvcourse_env\Scripts\activate
   pip install tensorflow keras
   ```

### For Production/Complete Setup:
1. Enable Windows long paths (one-time setup)
2. Restart computer
3. Use `requirements_minimal.txt` or `cvcourse_windows.txt`

---

## 📞 Getting Help

1. **Quick solutions** → `QUICK_FIX.md`
2. **Long path issues** → `FIX_LONG_PATH.md`
3. **Script usage** → `SETUP_GUIDE.md` or `SCRIPTS_REFERENCE.md`
4. **Other errors** → `TROUBLESHOOTING.md`

---

## 📊 Project Structure After Setup

```
Project/
├── Section_1/
│   └── cvcourse_env/           # Virtual environment
├── Section_2/
│   └── cvcourse_env/           # Virtual environment
├── Section_3/
│   └── cvcourse_env/           # Virtual environment
├── requirements_core.txt       # Recommended
├── requirements_minimal.txt
├── cvcourse_windows.txt
├── setup_env.py               # Main setup script
├── setup_env.ps1              # PowerShell version
├── setup_env.bat              # Batch version
├── enable_long_paths.ps1      # Fix long paths
└── [Documentation files]
```

---

## ✨ Tips

- **Use short folder names** (e.g., `S2` instead of `Section_2`) to avoid path issues
- **Close VS Code/IDEs** before running cleanup to avoid locked files
- **Keep environments separate** per section for isolation
- **Test with core requirements first** before adding complex packages
- **Enable long paths once** and never worry about it again

---

## 🎯 TL;DR (Too Long, Didn't Read)

**Just want it to work?**
```powershell
python setup_env.py Section_2 requirements_core.txt
.\Section_2\cvcourse_env\Scripts\Activate.ps1
```

**Want full features?**
```powershell
# Run as Admin once
.\enable_long_paths.ps1
# Restart computer
python setup_env.py Section_2 requirements_minimal.txt
.\Section_2\cvcourse_env\Scripts\Activate.ps1
```

Done! 🎉
