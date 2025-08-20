#!/bin/bash

# Color codes
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
    echo -e "${YELLOW}${BOLD} # # # # # # 🚀 GENSYN SWARM ROLL � # # # # # #${NC}"
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
    if go install github.com/Deep-Commit/gswarm/cmd/gswarm@latest; then
        echo -e "${GREEN}✅ gswarm installed successfully.${NC}"
    else
        echo -e "${RED}❌ Failed to install gswarm. Please ensure you have internet connectivity and the repository is accessible.${NC}"
        return 1
    fi

    echo -e "${GREEN}Go & gswarm installation completed.${NC}"
    return 0
}

enter_telegram_and_wallet_details() { # Function name updated
    echo -e "${GREEN}========== STEP 2: ENTER TELEGRAM & WALLET DETAILS ==========${NC}"

    read -e -p "${PINK}Enter your Telegram Bot Token (e.g., 12345:ABC-DEF): ${NC}" BOT_TOKEN_INPUT
    read -e -p "${PINK}Enter your Telegram Chat ID (e.g., 123456789): ${NC}" CHAT_ID_INPUT
    read -e -p "${PINK}Enter your EOA Wallet Address (e.g., 0x...): ${NC}" EOA_ADDRESS_INPUT

    # Basic validation for Telegram details
    if [[ -z "$BOT_TOKEN_INPUT" || -z "$CHAT_ID_INPUT" ]]; then
        echo -e "${RED}❌ Bot Token or Chat ID cannot be empty! Please try again.${NC}"
        return 1
    fi

    # Basic validation for Ethereum address (starts with 0x and is 42 chars long)
    if [[ ! "$EOA_ADDRESS_INPUT" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
        echo -e "${RED}❌ Invalid EOA Wallet Address format. It should start with '0x' and be 42 characters long.${NC}"
        return 1
    fi

    TELEGRAM_BOT_TOKEN="$BOT_TOKEN_INPUT"
    TELEGRAM_CHAT_ID="$CHAT_ID_INPUT"
    EOA_WALLET_ADDRESS="$EOA_ADDRESS_INPUT"

    echo -e "${GREEN}✅ Details saved successfully! ✨${NC}"
    echo -e "${CYAN}Bot Token: ${TELEGRAM_BOT_TOKEN:0:5}****${NC}"
    echo -e "${CYAN}Chat ID: ${TELEGRAM_CHAT_ID}${NC}"
    echo -e "${CYAN}Wallet Address: ${EOA_WALLET_ADDRESS}${NC}"
    return 0
}

go_discord_for_roll() { # New function for Discord link
    echo -e "${GREEN}========== STEP 3: GO DISCORD FOR ROLL ==========${NC}"
    echo -e "${CYAN}Join the Gensyn Discord for important updates and community support:${NC}"
    echo -e "${PINK}🔗 Discord Invite Link: https://discord.com/invite/gensyn ${NC}"
    echo -e "${CYAN}Please open this link in your web browser.${NC}"
}


run_gswarm() {
    echo -e "${GREEN}========== STEP 4: RUN GSWARM ==========${NC}"

    if ! command -v gswarm &> /dev/null; then
        echo -e "${RED}❌ gswarm executable not found. Please install it first (Option 1).${NC}"
        echo -e "${RED}Ensure Go path is set correctly and you've sourced your .bashrc.${NC}"
        return 1
    fi

    # Check if configurations are set by the user through our script
    if [ -z "$TELEGRAM_CHAT_ID" ] || [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$EOA_WALLET_ADDRESS" ]; then
        echo -e "${RED}❌ Telegram or EOA Wallet Address details are not set in this script's session.${NC}"
        echo -e "${RED}Please enter Telegram & Wallet Details first (Option 2).${NC}"
        return 1
    fi

    echo -e "${CYAN}🚀 Starting gswarm with your configured details...${NC}"
    echo -e "${CYAN}Bot Token (partial): ${TELEGRAM_BOT_TOKEN:0:5}****${NC}"
    echo -e "${CYAN}Chat ID: ${TELEGRAM_CHAT_ID}${NC}"
    echo -e "${CYAN}Wallet Address: ${EOA_WALLET_ADDRESS}${NC}"

    # Corrected gswarm command with proper flags from its help output
    gswarm --telegram-chat-id "$TELEGRAM_CHAT_ID" --telegram-bot-token "$TELEGRAM_BOT_TOKEN" --eoa-address "$EOA_WALLET_ADDRESS"

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
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}2${NC}${BOLD}] ${PINK}💬 Enter Telegram & Wallet Details${YELLOW}${BOLD} ║${NC}" # Updated text
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}3${NC}${BOLD}] ${PINK}🗣️ Go Discord for Roll           ${YELLOW}${BOLD} ║${NC}" # New option
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}4${NC}${BOLD}] ${PINK}🚀 Run gswarm                    ${YELLOW}${BOLD} ║${NC}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}0${NC}${BOLD}] ${PINK}👋 Exit                           ${YELLOW}${BOLD} ║${NC}"
    echo -e "${YELLOW}${BOLD}╚═══════════════════════════════════════╝${NC}"
    echo -e "" # Add a new line for better spacing
    read -p "Choose an option [0-4]: " choice

    case $choice in
        1) install_go_gswarm; read -p "Press Enter to continue..." ;;
        2) enter_telegram_and_wallet_details; read -p "Press Enter to continue..." ;; # Function name updated here
        3) go_discord_for_roll; read -p "Press Enter to continue..." ;; # New option handler
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
�
