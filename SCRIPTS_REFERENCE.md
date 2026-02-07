# Quick Reference - Setup Scripts

## 📋 All Available Scripts

| Script | Platform | Features | Usage |
|--------|----------|----------|-------|
| `setup_env.py` | All | ✅ Full featured<br>✅ Custom requirements<br>✅ Best error handling | `python setup_env.py [folder] [requirements]` |
| `setup_env.ps1` | Windows (PowerShell) | ✅ Full featured<br>✅ Custom requirements<br>✅ Colorful output | `.\setup_env.ps1 [folder] [requirements]` |
| `setup_env.bat` | Windows (CMD) | ✅ Full featured<br>✅ Custom requirements<br>✅ Works everywhere | `setup_env.bat [folder] [requirements]` |
| `setup_env.sh` | Linux/Mac/Git Bash | ✅ Full featured<br>✅ Colorful output<br>✅ Must source | `source setup_env.sh [folder]` |
| `activate_env.ps1` | Windows (PowerShell) | ✅ Simple<br>❌ No custom requirements | `.\activate_env.ps1 [folder]` |
| `activate_env.bat` | Windows (CMD) | ✅ Simple<br>❌ No custom requirements | `activate_env.bat [folder]` |

---

## 🎯 Quick Start (Choose One)

### Windows PowerShell (Recommended)
```powershell
# Full version with custom requirements support
.\setup_env.ps1 Section_2 requirements_minimal.txt

# Simpler version (uses cvcourse_windows.txt)
.\activate_env.ps1 Section_2
```

### Windows Command Prompt
```cmd
REM Full version with custom requirements support
setup_env.bat Section_2 requirements_minimal.txt

REM Simpler version (uses cvcourse_windows.txt)
activate_env.bat Section_2
```

### Python (Works everywhere)
```powershell
python setup_env.py Section_2 requirements_minimal.txt
```

### Linux/Mac/Git Bash
```bash
source setup_env.sh Section_2
```

---

## 🆚 Differences Between Scripts

### **`setup_env.*`** vs **`activate_env.*`**

| Feature | setup_env.* | activate_env.* |
|---------|-------------|----------------|
| Custom requirements file | ✅ Yes | ❌ No (always uses cvcourse_windows.txt) |
| Parameters | 2 (folder, requirements) | 1 (folder only) |
| Flexibility | High | Medium |
| Recommended for | Production use | Quick testing |

### Platform-Specific Versions

**`setup_env.py`** (Python)
- ✅ Works on all platforms
- ✅ Best error handling and retry logic
- ✅ Most features
- ❌ Requires Python to run

**`setup_env.ps1`** (PowerShell)
- ✅ Native Windows experience
- ✅ Colorful output
- ✅ Same features as Python version
- ❌ Windows only (PowerShell 5.1+)

**`setup_env.bat`** (Batch)
- ✅ Works on all Windows versions
- ✅ No prerequisites
- ✅ Same features as PowerShell version
- ❌ Less colorful output

**`setup_env.sh`** (Bash)
- ✅ Native Linux/Mac experience
- ✅ Colorful output
- ✅ Works in Git Bash on Windows
- ❌ Must be sourced (not just executed)

---

## 💡 Examples

### Example 1: Minimal installation
```powershell
# PowerShell
.\setup_env.ps1 Section_2 requirements_minimal.txt

# CMD
setup_env.bat Section_2 requirements_minimal.txt

# Python
python setup_env.py Section_2 requirements_minimal.txt
```

### Example 2: Full installation
```powershell
# PowerShell (uses default cvcourse_windows.txt)
.\setup_env.ps1 Section_2

# CMD
setup_env.bat Section_2

# Python
python setup_env.py Section_2
```

### Example 3: Legacy installation (old versions)
```powershell
# PowerShell
.\setup_env.ps1 Section_2 requirements_legacy.txt

# CMD
setup_env.bat Section_2 requirements_legacy.txt

# Python
python setup_env.py Section_2 requirements_legacy.txt
```

### Example 4: Current directory
```powershell
# PowerShell
.\setup_env.ps1

# CMD
setup_env.bat

# Python
python setup_env.py
```

---

## ⚡ Features Comparison

| Feature | Python | PS1 | BAT | SH |
|---------|--------|-----|-----|-----|
| Auto-cleanup | ✅ | ✅ | ✅ | ✅ |
| Retry on locked files | ✅ (3x) | ✅ (3x) | ✅ (3x) | ✅ |
| Custom requirements | ✅ | ✅ | ✅ | ❌* |
| Folder parameter | ✅ | ✅ | ✅ | ✅ |
| Python version check | ✅ | ✅ | ✅ | ❌ |
| Pip upgrade | ✅ | ✅ | ✅ | ✅ |
| Colored output | ❌ | ✅ | ❌ | ✅ |
| Error messages | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐⭐ |
| Cross-platform | ✅ | ❌ | ❌ | ⭐ |

*Can be added if needed

---

## 🎓 Recommendation

**For Windows users:**
- **Best:** `setup_env.ps1` (PowerShell) - Full features, colorful, native
- **Alternative:** `setup_env.bat` (CMD) - Works everywhere, slightly less pretty
- **Universal:** `python setup_env.py` - If you want consistency across platforms

**For Linux/Mac users:**
- **Best:** `source setup_env.sh` - Native bash experience
- **Alternative:** `python setup_env.py` - More features

**For beginners:**
- Start with `setup_env.bat` (CMD) or `setup_env.ps1` (PowerShell) - simplest to use

**For advanced users:**
- Use `python setup_env.py` for maximum control and error handling
