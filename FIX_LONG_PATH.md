# Fix for Windows Long Path Issue

## Problem
Windows has a 260-character path length limit by default, which causes issues when installing packages like Jupyter that have deep directory structures.

## Solution 1: Enable Long Path Support (Recommended)

### Option A: Using Registry Editor (Requires Admin)
1. Press `Win + R`, type `regedit`, and press Enter
2. Navigate to: `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem`
3. Find or create a DWORD value named `LongPathsEnabled`
4. Set its value to `1`
5. Restart your computer

### Option B: Using PowerShell (Requires Admin)
Run PowerShell as Administrator and execute:
```powershell
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
```
Then restart your computer.

### Option C: Using Group Policy Editor (Windows Pro/Enterprise)
1. Press `Win + R`, type `gpedit.msc`, and press Enter
2. Navigate to: Computer Configuration → Administrative Templates → System → Filesystem
3. Double-click "Enable Win32 long paths"
4. Select "Enabled"
5. Click OK and restart

## Solution 2: Use Shorter Path (Quick Fix - No Admin Required)

Instead of using `.\Section_2\`, use a shorter base path:

### Move to a shorter location:
```powershell
# Option 1: Use drive root
cd C:\CV
python setup_env.py Section_2 requirements_minimal.txt

# Option 2: Use shorter folder name
cd C:\git
mkdir CV
cd CV
# Copy your scripts here
python setup_env.py Section_2 requirements_minimal.txt
```

### Or create environment at root level:
```powershell
# From your current location
python setup_env.py C:\envs\cv requirements_minimal.txt
```

## Solution 3: Install Packages Without JupyterLab Extensions

Create a minimal requirements file without problematic packages:

```powershell
# Use the ultra-minimal requirements
python setup_env.py .\Section_2\ requirements_core.txt
```

Then install Jupyter separately with workarounds.

## Solution 4: Use Conda Instead (Alternative)

Conda handles long paths better:
```powershell
conda env create -f cvcourse_windows.yml
```

## Immediate Workaround (No Admin, No Moving Files)

Try installing without jupyter lab extensions:
```powershell
# 1. Create environment
python -m venv .\S2\env

# 2. Activate it
.\S2\env\Scripts\activate

# 3. Install packages one by one
pip install numpy opencv-python opencv-contrib-python scikit-learn matplotlib pillow
pip install notebook  # Basic Jupyter without lab extensions
```

## After Enabling Long Paths

Once you've enabled long paths and restarted:
```powershell
# Clean and recreate
python setup_env.py .\Section_2\ requirements_minimal.txt
```

The installation should complete successfully!
