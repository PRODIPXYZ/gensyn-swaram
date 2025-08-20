#!/bin/bash

# Color codes (Re-using the successful palette from the previous script)
YELLOW='\033[1;33m'     # Bold Yellow
BOLD='\033[1m'          # General Bold
CYAN='\033[1;36m'       # Bold Cyan
GREEN='\033[1;32m'      # Bold Green
PINK='\033[38;5;198m'   # Deep Pink (Using 256-color code for specific shade)
RED='\033[1;31m'        # Bold Red
NC='\033[0m'            # No Color

# --- Global Variables for Configuration ---
# These will store user inputs for Telegram and Wallet Address
TELEGRAM_CHAT_ID=""
TELEGRAM_BOT_TOKEN=""
EOA_WALLET_ADDRESS=""

# --- Function to print the header ---
print_header() {
    clear # Clear screen to ensure header is always at the top
    echo -e "${YELLOW}${BOLD}=====================================================${NC}"
    echo -e "${YELLOW}${BOLD} # # # # # # 🚀 GENSYN SWARM ROLL 🚀 # # # # # #${NC}"
    echo -e "${YELLOW}${BOLD} # # # # # #   MADE BY PRODIP   # # # # # #${NC}"
    echo -e "${YELLOW}${BOLD} # # # # # #   DM TG: @prodipgo   # # # # # #${NC}"
    echo -e "${YELLOW}${BOLD}=====================================================${NC}"
    echo -e ""
}

# --- Functions for each menu option ---

install_go_gswarm() {
    echo -e "${GREEN}========== STEP 1: INSTALL GO & GSWARM ==========${NC}"
    echo -e "${CYAN}Starting Go & gswarm installation...${NC}"

    # Check if Go is installed and install if not
    if ! command -v go &> /dev/null; then
        echo -e "${GREEN}🔧 Installing Go (version 1.22.2)...${NC}"
        # Download and install Go version 1.22.2 as per provided script
        if ! wget -q https://go.dev/dl/go1.22.2.linux-amd64.tar.gz; then
            echo -e "${RED}❌ Failed to download Go. Please check your internet connection.${NC}"
            return 1
        fi
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz
        rm go1.22.2.linux-amd64.tar.gz
        echo -e "${GREEN}Go installed successfully.${NC}"
    else
        echo -e "${GREEN}✅ Go is already installed.${NC}"
    fi

    # Set Go path for current script session
    export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

    # Optional: Add to ~/.bashrc for future sessions if not already present
    if ! grep -q "export PATH=.*:/usr/local/go/bin" "$HOME/.bashrc"; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> "$HOME/.bashrc"
    fi
    if ! grep -q "export PATH=.*:$HOME/go/bin" "$HOME/.bashrc"; then
        echo 'export PATH=$PATH:$HOME/go/bin' >> "$HOME/.bashrc"
    fi
    source "$HOME/.bashrc" # Source immediately for current session

    # Verify Go installation
    echo -e "${CYAN}Verifying Go installation:${NC}"
    go version

    # Create go/bin folder if needed
    mkdir -p "$HOME/go/bin"
    echo -e "${GREEN}Created ~/go/bin directory.${NC}"

    # Install gswarm
    echo -e "${CYAN}⚙️ Installing gswarm...${NC}"
    # Using the correct path for gswarm as provided by you
    if go install github.com/Deep-Commit/gswarm/cmd/gswarm@latest; then
        echo -e "${GREEN}✅ gswarm installed successfully.${NC}"
    else
        echo -e "${RED}❌ Failed to install gswarm. Please ensure you have internet connectivity and the repository is accessible.${NC}"
        return 1
    fi

    echo -e "${GREEN}Go & gswarm installation completed.${NC}"
    return 0
}

enter_telegram_details() {
    echo -e "${GREEN}========== STEP 2: ENTER TELEGRAM DETAILS ==========${NC}"
    read -e -p "${PINK}Enter your Telegram Chat ID (e.g., 123456789): ${NC}" CHAT_ID_INPUT
    read -e -p "${PINK}Enter your Telegram Bot Token (e.g., 12345:ABC-DEF): ${NC}" BOT_TOKEN_INPUT

    # Basic validation for Telegram details
    if [[ -z "$CHAT_ID_INPUT" || -z "$BOT_TOKEN_INPUT" ]]; then
        echo -e "${RED}❌ Chat ID or Bot Token cannot be empty! Please try again.${NC}"
    else
        TELEGRAM_CHAT_ID="$CHAT_ID_INPUT"
        TELEGRAM_BOT_TOKEN="$BOT_TOKEN_INPUT"
        echo -e "${GREEN}✅ Telegram details saved! ✨${NC}"
        echo -e "${CYAN}Chat ID: ${TELEGRAM_CHAT_ID}${NC}"
        echo -e "${CYAN}Bot Token: ${TELEGRAM_BOT_TOKEN:0:5}****${NC}" # Masking token for display
    fi
}

enter_eoa_wallet_address() {
    echo -e "${GREEN}========== STEP 3: ENTER EOA WALLET ADDRESS ==========${NC}"
    read -e -p "${PINK}Enter your EOA Wallet Address (e.g., 0x...): ${NC}" EOA_ADDRESS_INPUT

    # Basic validation for Ethereum address (starts with 0x and is 42 chars long)
    if [[ "$EOA_ADDRESS_INPUT" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
        EOA_WALLET_ADDRESS="$EOA_ADDRESS_INPUT"
        echo -e "${GREEN}✅ EOA address saved! 💰${NC}"
        echo -e "${CYAN}Wallet Address: ${EOA_WALLET_ADDRESS}${NC}"
    else
        echo -e "${RED}❌ Invalid EOA Wallet Address format. It should start with '0x' and be 42 characters long.${NC}"
    fi
}

run_gswarm() {
    echo -e "${GREEN}========== STEP 4: RUN GSWARM ==========${NC}"

    # Check if gswarm executable is in PATH
    if ! command -v gswarm &> /dev/null; then
        echo -e "${RED}❌ gswarm executable not found. Please install it first (Option 1).${NC}"
        echo -e "${RED}Ensure Go path is set correctly and you've sourced your .bashrc.${NC}"
        return 1
    fi

    echo -e "${CYAN}🚀 Starting gswarm...${NC}"
    # Executing gswarm as per the provided script
    gswarm
    echo -e "${GREEN}gswarm command executed. Monitor its output for status.${NC}"
    echo -e "${CYAN}Note: This script only starts gswarm. It might run indefinitely.${NC}"
}

# --- Main loop for the menu ---
while true; do
    print_header # Display the main header
    echo -e "${YELLOW}${BOLD}╔═══════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}${BOLD}║      🔵 GENSYN SWARM ROLL MENU 🔵    ║${NC}"
    echo -e "${YELLOW}${BOLD}╠═══════════════════════════════════════╣${NC}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}1${NC}${BOLD}] ${PINK}📦 Install Go & gswarm            ${YELLOW}${BOLD}  ║${NC}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}2${NC}${BOLD}] ${PINK}💬 Enter Telegram Details         ${YELLOW}${BOLD} ║${NC}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}3${NC}${BOLD}] ${PINK}💳 Enter EOA Wallet Address      ${YELLOW}${BOLD} ║${NC}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}4${NC}${BOLD}] ${PINK}🚀 Run gswarm                    ${YELLOW}${BOLD} ║${NC}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}0${NC}${BOLD}] ${PINK}👋 Exit                           ${YELLOW}${BOLD} ║${NC}"
    echo -e "${YELLOW}${BOLD}╚═══════════════════════════════════════╝${NC}"
    echo -e "" # Add a new line for better spacing
    read -p "Choose an option [0-4]: " choice

    case $choice in
        1) install_go_gswarm; read -p "Press Enter to continue..." ;;
        2) enter_telegram_details; read -p "Press Enter to continue..." ;;
        3) enter_eoa_wallet_address; read -p "Press Enter to continue..." ;;
        4) run_gswarm; read -p "Press Enter to continue..." ;;
        0)
            echo -e "🚪 Exiting... Bye! 👋"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid choice! Please enter a number between 0 and 4.${NC}"
            sleep 1
            ;;
    esac

done
