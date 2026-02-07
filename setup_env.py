"""
Setup script to create and manage Python virtual environment
Usage: python setup_env.py [folder_name] [requirements_file]
Example: python setup_env.py Section_2
Example: python setup_env.py Section_2 requirements_legacy.txt
"""
import os
import sys
import subprocess
import platform
import shutil
import time

# Enable PowerShell script execution on Windows
if platform.system() == "Windows":
    try:
        subprocess.run(
            ["powershell", "-Command", "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force"],
            capture_output=True,
            check=False
        )
    except:
        pass  # Ignore errors if PowerShell is not available

# Get folder name from command line argument or use default
if len(sys.argv) > 1:
    FOLDER_NAME = sys.argv[1]
    ENV_NAME = os.path.join(FOLDER_NAME, "cvcourse_env")
else:
    FOLDER_NAME = None
    ENV_NAME = "cvcourse_env"

# Get requirements file from command line or use default
if len(sys.argv) > 2:
    REQUIREMENTS_FILE = sys.argv[2]
else:
    REQUIREMENTS_FILE = "cvcourse_windows.txt"

def run_command(command, shell=True):
    """Execute a shell command and return the result"""
    try:
        result = subprocess.run(command, shell=shell, check=True, 
                              capture_output=True, text=True)
        print(result.stdout)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error: {e.stderr}")
        return False

def create_virtual_env():
    """Create a Python virtual environment"""
    # Clean existing environment if it exists
    if os.path.exists(ENV_NAME):
        print(f"Cleaning existing environment: {ENV_NAME}")
        try:
            # Try multiple times with delays (handles locked files on Windows)
            for attempt in range(3):
                try:
                    if platform.system() == "Windows":
                        # On Windows, use more aggressive removal
                        subprocess.run(['cmd', '/c', 'rmdir', '/s', '/q', ENV_NAME], 
                                     check=False, capture_output=True)
                    shutil.rmtree(ENV_NAME, ignore_errors=True)
                    
                    if not os.path.exists(ENV_NAME):
                        print(f"✓ Old environment removed successfully")
                        break
                    time.sleep(1)  # Wait before retry
                except Exception as e:
                    if attempt == 2:  # Last attempt
                        raise e
                    time.sleep(1)
        except Exception as e:
            print(f"✗ Failed to remove old environment: {e}")
            print("Please close any programs using the environment and try again")
            print(f"Or manually delete: {ENV_NAME}")
            return False
    
    print(f"Creating virtual environment: {ENV_NAME}")
    
    # Create folder if it doesn't exist
    if FOLDER_NAME and not os.path.exists(FOLDER_NAME):
        print(f"Creating folder: {FOLDER_NAME}")
        os.makedirs(FOLDER_NAME, exist_ok=True)
    
    if run_command(f"python -m venv {ENV_NAME}"):
        print(f"✓ Virtual environment '{ENV_NAME}' created successfully")
        return True
    else:
        print(f"✗ Failed to create virtual environment")
        return False

def get_pip_path():
    """Get the path to pip executable in the virtual environment"""
    if platform.system() == "Windows":
        return os.path.join(ENV_NAME, "Scripts", "pip.exe")
    else:
        return os.path.join(ENV_NAME, "bin", "pip")

def get_python_path():
    """Get the path to python executable in the virtual environment"""
    if platform.system() == "Windows":
        return os.path.join(ENV_NAME, "Scripts", "python.exe")
    else:
        return os.path.join(ENV_NAME, "bin", "python")

def upgrade_pip():
    """Upgrade pip to the latest version"""
    print("\nUpgrading pip...")
    python_path = get_python_path()
    # Use the virtual environment's Python to upgrade pip
    return run_command(f'"{python_path}" -m pip install --upgrade pip')

def install_requirements():
    """Install packages from requirements.txt"""
    if not os.path.exists(REQUIREMENTS_FILE):
        print(f"✗ Requirements file '{REQUIREMENTS_FILE}' not found")
        return False
    
    print(f"\nInstalling packages from {REQUIREMENTS_FILE}...")
    print("-" * 60)
    
    # Read requirements file and count packages
    with open(REQUIREMENTS_FILE, 'r') as f:
        packages = [line.strip() for line in f 
                   if line.strip() and not line.strip().startswith('#')]
    
    total_packages = len(packages)
    print(f"Found {total_packages} packages to install\n")
    
    python_path = get_python_path()
    success_count = 0
    failed_packages = []
    
    # Install packages one by one for progress tracking
    for i, package in enumerate(packages, 1):
        print(f"[{i}/{total_packages}] Installing {package}...", end=" ", flush=True)
        
        result = subprocess.run(
            f'"{python_path}" -m pip install "{package}" --quiet',
            shell=True,
            capture_output=True,
            text=True
        )
        
        if result.returncode == 0:
            print("✓")
            success_count += 1
        else:
            print("✗")
            failed_packages.append(package)
    
    print("-" * 60)
    print(f"\nInstallation Summary:")
    print(f"  ✓ Successful: {success_count}/{total_packages}")
    
    if failed_packages:
        print(f"  ✗ Failed: {len(failed_packages)}/{total_packages}")
        print(f"\nFailed packages:")
        for pkg in failed_packages:
            print(f"    - {pkg}")
        return False
    else:
        print(f"✓ All packages installed successfully")
        return True

def get_activation_command():
    """Get the command to activate the virtual environment"""
    if platform.system() == "Windows":
        return f".\\{ENV_NAME}\\Scripts\\Activate.ps1"
    else:
        return f"source {ENV_NAME}/bin/activate"

def main():
    """Main setup function"""
    print("=" * 60)
    print("Python Virtual Environment Setup")
    print("=" * 60)
    
    if FOLDER_NAME:
        print(f"Target folder: {FOLDER_NAME}")
    print(f"Environment path: {ENV_NAME}")
    print(f"Requirements file: {REQUIREMENTS_FILE}")
    print("=" * 60)
    
    # Create virtual environment
    if not create_virtual_env():
        sys.exit(1)
    
    # Upgrade pip
    upgrade_pip()
    
    # Install requirements
    if not install_requirements():
        sys.exit(1)
    
    print("\n" + "=" * 60)
    print("✓ Setup completed successfully!")
    print("=" * 60)
    print(f"\nTo activate the virtual environment, run:")
    print(f"  {get_activation_command()}")
    print(f"\nTo deactivate when done, run:")
    print(f"  deactivate")
    print("=" * 60)
    
    # Ask if user wants to activate now
    print("\nWould you like to activate the environment now? (y/n): ", end="", flush=True)
    try:
        response = input().strip().lower()
        if response in ['y', 'yes']:
            print("\nActivating environment...")
            
            # Change to the target directory
            if FOLDER_NAME:
                print(f"Changing directory to: {FOLDER_NAME}")
                try:
                    os.chdir(FOLDER_NAME)
                    print(f"✓ Changed to: {os.getcwd()}")
                except Exception as e:
                    print(f"⚠ Could not change directory: {e}")
            
            print(f"\nRun the following command to activate:")
            print(f"  {get_activation_command()}")
            print("\nNote: Activation from Python script has limitations.")
            print("Please run the activation command manually in your terminal.")
        else:
            print("\nEnvironment ready. Activate it manually when needed.")
    except (KeyboardInterrupt, EOFError):
        print("\n\nEnvironment ready. Activate it manually when needed.")
    
    print("=" * 60)

if __name__ == "__main__":
    main()
