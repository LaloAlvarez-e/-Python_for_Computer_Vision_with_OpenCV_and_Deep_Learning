# Auto Directory Change Feature

## ✨ New Enhancement

When you choose to activate the environment, the script now **automatically changes to the target folder**!

---

## 🎯 How It Works

### Before (Old Behavior):
```powershell
PS C:\git\project> python setup_env.py Section_2
...
Would you like to activate the environment now? (y/n): y

Activating environment...
✓ Environment activated successfully!

(Section_2\cvcourse_env) PS C:\git\project>  # Still in project root
```

### After (New Behavior):
```powershell
PS C:\git\project> python setup_env.py Section_2
...
Would you like to activate the environment now? (y/n): y

Activating environment...
Changing directory to: C:\git\project\Section_2
✓ Changed to: C:\git\project\Section_2
✓ Environment activated successfully!

(cvcourse_env) PS C:\git\project\Section_2>  # Now in Section_2 folder!
```

---

## 🚀 Benefits

✅ **Ready to work** - Already in the correct directory  
✅ **Less confusion** - Clear context of where you are  
✅ **Fewer commands** - No need to manually `cd` after activation  
✅ **Better workflow** - Start coding immediately  
✅ **Clear feedback** - Shows exactly where it's changing to  

---

## 📋 Available in All Scripts

This works in:
- ✅ `setup_env.py` (Python) - Changes Python's working directory
- ✅ `setup_env.ps1` (PowerShell) - Uses `Set-Location`
- ✅ `setup_env.bat` (Batch) - Uses `cd /d`
- ✅ `setup_env.sh` (Bash) - Uses `cd`
- ✅ `activate_env.ps1` (PowerShell simple)
- ✅ `activate_env.bat` (Batch simple)

---

## 💡 Examples

### Example 1: Setup for Section_2

```powershell
PS C:\git\CV_Course> python setup_env.py Section_2 requirements_core.txt

[... installation process ...]

============================================================
✓ Setup completed successfully!
============================================================

To activate the virtual environment, run:
  .\Section_2\cvcourse_env\Scripts\Activate.ps1

To deactivate when done, run:
  deactivate
============================================================

Would you like to activate the environment now? (y/n): y

Activating environment...
Changing directory to: C:\git\CV_Course\Section_2
✓ Changed to: C:\git\CV_Course\Section_2
✓ Environment activated successfully!

You can now use Python with all installed packages.
Type 'deactivate' when you're done.
============================================================

(cvcourse_env) PS C:\git\CV_Course\Section_2>
```

Now you're ready to work directly in the Section_2 folder!

### Example 2: Multiple Sections Workflow

```powershell
PS C:\project> python setup_env.py Section_1 requirements_core.txt
Would you like to activate now? (y/n): n  # Skip for batch creation

PS C:\project> python setup_env.py Section_2 requirements_core.txt
Would you like to activate now? (y/n): n  # Skip for batch creation

PS C:\project> python setup_env.py Section_3 requirements_core.txt
Would you like to activate now? (y/n): y  # Activate this one

Changing directory to: C:\project\Section_3
✓ Changed to: C:\project\Section_3
✓ Environment activated!

(cvcourse_env) PS C:\project\Section_3>  # Ready to work in Section_3
```

### Example 3: No Folder Specified

```powershell
PS C:\project> python setup_env.py
...
Would you like to activate now? (y/n): y

Activating environment...
✓ Environment activated successfully!

(cvcourse_env) PS C:\project>  # Stays in current directory
```

*Note: If no folder is specified, it stays in the current directory.*

---

## 🔧 Technical Details

### How Directory Change Works:

**PowerShell (`.ps1`):**
```powershell
$targetDir = Resolve-Path $FolderName
Set-Location $targetDir
```

**Batch (`.bat`):**
```batch
cd /d "%FOLDER_NAME%"
```
*The `/d` flag allows changing drives*

**Bash (`.sh`):**
```bash
cd "$FOLDER_NAME"
```

**Python (`.py`):**
```python
os.chdir(target_dir)
```
*Note: Only changes Python's working directory, not the terminal*

---

## 🎓 Use Cases

### Use Case 1: Course Structure
```
CV_Course/
├── Section_1/
│   ├── cvcourse_env/
│   └── code/  # Your code files here
├── Section_2/
│   ├── cvcourse_env/
│   └── code/  # Your code files here
└── Section_3/
    ├── cvcourse_env/
    └── code/  # Your code files here
```

When you activate Section_2:
- Changes to `Section_2` folder
- You can immediately access `code/` subfolder
- No need to remember which section you're working on

### Use Case 2: Jupyter Notebooks
```powershell
PS C:\project> python setup_env.py Section_2 requirements_core.txt
Would you like to activate now? (y/n): y

Changing directory to: C:\project\Section_2
✓ Changed to: C:\project\Section_2
✓ Environment activated!

(cvcourse_env) PS C:\project\Section_2> jupyter notebook
# Opens Jupyter with Section_2 as the working directory
```

### Use Case 3: Running Scripts
```powershell
PS C:\project> .\setup_env.ps1 Section_2
Would you like to activate now? (y/n): y

Changing directory to: C:\project\Section_2
✓ Changed to: C:\project\Section_2

(cvcourse_env) PS C:\project\Section_2> python my_script.py
# Runs script from Section_2 directory
```

---

## ⚠️ Important Notes

### Python Script Limitation:
The Python script (`setup_env.py`) changes Python's internal working directory, but **cannot change your terminal's directory** due to how subprocesses work. You'll need to manually `cd` to the folder after running the script.

### PowerShell/Batch/Bash:
These scripts **can change** the terminal's directory because they run within the shell itself.

### Error Handling:
If the directory doesn't exist or can't be accessed:
```
Changing directory to: Section_2
⚠ Could not change directory
```
The script continues but stays in the current directory.

---

## 🎨 Visual Flow

```
┌──────────────────────────┐
│  User Chooses Activate   │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│  Folder Name Specified?  │
└────┬──────────────┬──────┘
     │ Yes          │ No
     ▼              ▼
┌──────────┐  ┌──────────┐
│ Change   │  │ Stay in  │
│ Directory│  │ Current  │
└────┬─────┘  └────┬─────┘
     │              │
     └──────┬───────┘
            ▼
┌──────────────────────────┐
│  Activate Environment    │
└────────────┬─────────────┘
             ▼
┌──────────────────────────┐
│  Ready to Work!          │
└──────────────────────────┘
```

---

## 📊 Comparison Table

| Scenario | Old Behavior | New Behavior |
|----------|--------------|--------------|
| `setup_env.py Section_2` then activate | Stay in project root | Change to Section_2 |
| `setup_env.ps1 Section_2` then activate | Stay in project root | Change to Section_2 |
| `setup_env.py` (no folder) then activate | Stay in current dir | Stay in current dir |
| Choose 'n' (don't activate) | Stay in current dir | Stay in current dir |

---

## 💬 User Feedback

### When Directory Change Succeeds:
```
Changing directory to: C:\project\Section_2
✓ Changed to: C:\project\Section_2
```

### When Directory Change Fails:
```
Changing directory to: Section_2
⚠ Could not change directory
```

### When No Folder Specified:
```
# No directory change message shown
✓ Environment activated successfully!
```

---

## 🔑 Tips

1. **Always specify a folder** when creating environments for different sections
   ```powershell
   python setup_env.py Section_2  # ✅ Good
   python setup_env.py            # ⚠️ No folder change
   ```

2. **Check your prompt** after activation to see where you are
   ```powershell
   (cvcourse_env) PS C:\project\Section_2>  # You're in Section_2
   ```

3. **Use absolute paths** if you want to be explicit
   ```powershell
   python setup_env.py C:\MyProjects\Section_2
   ```

4. **Navigate freely** after activation - you're not locked in
   ```powershell
   (cvcourse_env) PS C:\project\Section_2> cd ..\Section_3
   (cvcourse_env) PS C:\project\Section_3>
   ```

---

## ✨ Summary

This enhancement makes your workflow smoother by:
1. ✅ Automatically moving you to the target folder
2. ✅ Reducing the number of commands you need to type
3. ✅ Providing clear feedback about where you are
4. ✅ Getting you ready to work immediately

No more forgetting to `cd` to the right folder! 🎉
