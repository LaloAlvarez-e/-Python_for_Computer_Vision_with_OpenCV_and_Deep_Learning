#!/bin/bash
# Bash script to setup and activate Python virtual environment
#    # Install/Update requirements
    if [ -f "$REQUIREMENTS_FILE" ]; then
        echo -e "\n${YELLOW}Installing packages from $REQUIREMENTS_FILE...${NC}"
        echo -e "${CYAN}============================================================${NC}"
        
        # Read requirements file and count packages
        PACKAGES=($(grep -v '^#' "$REQUIREMENTS_FILE" | grep -v '^[[:space:]]*$'))
        TOTAL_PACKAGES=${#PACKAGES[@]}
        echo -e "${NC}Found $TOTAL_PACKAGES packages to install\n"
        
        SUCCESS_COUNT=0
        FAILED_PACKAGES=()
        INDEX=0
        
        # Install packages one by one for progress tracking
        for package in "${PACKAGES[@]}"; do
            INDEX=$((INDEX + 1))
            echo -n -e "${NC}[$INDEX/$TOTAL_PACKAGES] Installing $package... "
            
            if pip install "$package" --quiet > /dev/null 2>&1; then
                echo -e "${GREEN}✓${NC}"
                SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
            else
                echo -e "${RED}✗${NC}"
                FAILED_PACKAGES+=("$package")
            fi
        done
        
        echo -e "\n${CYAN}============================================================${NC}"
        echo -e "\n${YELLOW}Installation Summary:${NC}"
        echo -e "${GREEN}  ✓ Successful: $SUCCESS_COUNT/$TOTAL_PACKAGES${NC}"
        
        if [ ${#FAILED_PACKAGES[@]} -gt 0 ]; then
            echo -e "${RED}  ✗ Failed: ${#FAILED_PACKAGES[@]}/$TOTAL_PACKAGES${NC}"
            echo -e "\n${RED}Failed packages:${NC}"
            for pkg in "${FAILED_PACKAGES[@]}"; do
                echo -e "${RED}    - $pkg${NC}"
            done
            echo -e "\n${RED}✗ Some packages failed to install${NC}"
        else
            echo -e "\n${GREEN}✓ All packages installed successfully${NC}"
        fiurce setup_env.sh [folder_name] or . setup_env.sh [folder_name]
# Example: source setup_env.sh Section_2

# Get folder name from command line argument or use default
if [ -n "$1" ]; then
    FOLDER_NAME="$1"
    ENV_NAME="$FOLDER_NAME/cvcourse_env"
else
    FOLDER_NAME=""
    ENV_NAME="cvcourse_env"
fi

REQUIREMENTS_FILE="cvcourse_windows.txt"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}============================================================${NC}"
echo -e "${GREEN}Python Virtual Environment Setup${NC}"
echo -e "${CYAN}============================================================${NC}"

if [ -n "$FOLDER_NAME" ]; then
    echo -e "${NC}Target folder: ${YELLOW}$FOLDER_NAME${NC}"
fi
echo -e "${NC}Environment path: ${YELLOW}$ENV_NAME${NC}"
echo -e "${CYAN}============================================================${NC}"

# Create folder if it doesn't exist
if [ -n "$FOLDER_NAME" ] && [ ! -d "$FOLDER_NAME" ]; then
    echo -e "\n${YELLOW}Creating folder: $FOLDER_NAME${NC}"
    mkdir -p "$FOLDER_NAME"
fi

# Clean existing environment if it exists
if [ -d "$ENV_NAME" ]; then
    echo -e "\n${YELLOW}Cleaning existing environment: $ENV_NAME${NC}"
    rm -rf "$ENV_NAME"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Old environment removed successfully${NC}"
    else
        echo -e "${RED}✗ Failed to remove old environment${NC}"
        return 1 2>/dev/null || exit 1
    fi
fi

# Check if virtual environment exists
if [ ! -d "$ENV_NAME" ]; then
    echo -e "\n${YELLOW}Creating virtual environment: $ENV_NAME${NC}"
    python3 -m venv "$ENV_NAME"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}✗ Failed to create virtual environment${NC}"
        return 1 2>/dev/null || exit 1
    fi
    echo -e "${GREEN}✓ Virtual environment created successfully${NC}"
else
    echo -e "\n${GREEN}✓ Virtual environment '$ENV_NAME' already exists${NC}"
fi

# Activate virtual environment
echo -e "\n${YELLOW}Activating virtual environment...${NC}"
source "$ENV_NAME/bin/activate"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Virtual environment activated${NC}"
    
    # Upgrade pip
    echo -e "\n${YELLOW}Upgrading pip...${NC}"
    pip install --upgrade pip --quiet
    
    # Install/Update requirements
    if [ -f "$REQUIREMENTS_FILE" ]; then
        echo -e "\n${YELLOW}Installing packages from $REQUIREMENTS_FILE...${NC}"
        echo -e "${CYAN}============================================================${NC}"
        
        # Read requirements file and count packages
        PACKAGES=($(grep -v '^#' "$REQUIREMENTS_FILE" | grep -v '^[[:space:]]*$'))
        TOTAL_PACKAGES=${#PACKAGES[@]}
        echo -e "${NC}Found $TOTAL_PACKAGES packages to install\n"
        
        SUCCESS_COUNT=0
        FAILED_PACKAGES=()
        INDEX=0
        
        # Install packages one by one for progress tracking
        for package in "${PACKAGES[@]}"; do
            INDEX=$((INDEX + 1))
            echo -n -e "${NC}[$INDEX/$TOTAL_PACKAGES] Installing $package... "
            
            if pip install "$package" --quiet > /dev/null 2>&1; then
                echo -e "${GREEN}✓${NC}"
                SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
            else
                echo -e "${RED}✗${NC}"
                FAILED_PACKAGES+=("$package")
            fi
        done
        
        echo -e "\n${CYAN}============================================================${NC}"
        echo -e "\n${YELLOW}Installation Summary:${NC}"
        echo -e "${GREEN}  ✓ Successful: $SUCCESS_COUNT/$TOTAL_PACKAGES${NC}"
        
        if [ ${#FAILED_PACKAGES[@]} -gt 0 ]; then
            echo -e "${RED}  ✗ Failed: ${#FAILED_PACKAGES[@]}/$TOTAL_PACKAGES${NC}"
            echo -e "\n${RED}Failed packages:${NC}"
            for pkg in "${FAILED_PACKAGES[@]}"; do
                echo -e "${RED}    - $pkg${NC}"
            done
            echo -e "\n${RED}✗ Some packages failed to install${NC}"
        else
            echo -e "\n${GREEN}✓ All packages installed successfully${NC}"
        fi
    else
        echo -e "\n${RED}✗ Requirements file '$REQUIREMENTS_FILE' not found${NC}"
    fi
    
    echo -e "\n${CYAN}============================================================${NC}"
    echo -e "${GREEN}✓ Setup completed!${NC}"
    echo -e "${CYAN}============================================================${NC}"
    echo -e "${NC}\nTo activate the virtual environment, run:"
    echo -e "${YELLOW}  source $ENV_NAME/bin/activate${NC}"
    echo -e "${NC}\nTo deactivate when done, run:"
    echo -e "${YELLOW}  deactivate${NC}"
    echo -e "${CYAN}============================================================${NC}"
    
    # Ask if user wants to activate now
    echo -e "\n${YELLOW}Would you like to activate the environment now? (y/n): ${NC}\c"
    read -r response
    
    if [ "$response" = "y" ] || [ "$response" = "Y" ] || [ "$response" = "yes" ] || [ "$response" = "Yes" ]; then
        echo -e "\n${GREEN}Activating environment...${NC}"
        
        # Change to the target directory if folder was specified
        if [ -n "$FOLDER_NAME" ]; then
            echo -e "${YELLOW}Changing directory to: $FOLDER_NAME${NC}"
            if cd "$FOLDER_NAME" 2>/dev/null; then
                echo -e "${GREEN}✓ Changed to: $(pwd)${NC}"
            else
                echo -e "${YELLOW}⚠ Could not change directory${NC}"
            fi
        fi
        
        source "$ENV_NAME/bin/activate"
        
        if [ -n "$VIRTUAL_ENV" ]; then
            echo -e "${GREEN}✓ Environment activated successfully!${NC}"
            echo -e "\n${NC}You can now use Python with all installed packages."
            echo -e "Type ${YELLOW}'deactivate'${NC} when you're done."
        else
            echo -e "${YELLOW}⚠ Environment may not be active in this session.${NC}"
            echo -e "${YELLOW}You may need to source the activation script manually.${NC}"
        fi
    else
        echo -e "\n${NC}Environment ready. Activate it manually when needed."
    fi
    
    echo -e "${CYAN}============================================================${NC}"
else
    echo -e "${RED}✗ Failed to activate virtual environment${NC}"
    return 1 2>/dev/null || exit 1
fi
