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

    # Check if Go is installed
    if ! command -v go &> /dev/null; then
        echo -e "${GREEN}🔧 Installing Go...${NC}"
        # Fetch the latest Go version dynamically
        GO_VERSION=$(curl -s "https://go.dev/dl/?mode=json&limit=1" | jq -r '.[0].version')
        GO_TARBALL="${GO_VERSION}.linux-amd64.tar.gz"
        GO_DOWNLOAD_URL="https://go.dev/dl/${GO_TARBALL}"

        echo -e "${CYAN}Downloading ${GO_VERSION}...${NC}"
        if ! wget -q "$GO_DOWNLOAD_URL"; then
            echo -e "${RED}❌ Failed to download Go. Please check your internet connection.${NC}"
            return 1
        fi

        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf "$GO_TARBALL"
        rm "$GO_TARBALL"

        # Add Go to PATH if not already present
        if ! grep -q "export PATH=.*:/usr/local/go/bin" "$HOME/.bashrc"; then
            echo "export PATH=$PATH:/usr/local/go/bin" >> "$HOME/.bashrc"
            echo -e "${GREEN}Added Go to .bashrc. Please source your .bashrc or restart your terminal.${NC}"
        fi
        source "$HOME/.bashrc" # Source immediately for current session
    else
        echo -e "${GREEN}✅ Go is already installed.${NC}"
    fi

    echo -e "${CYAN}Installing gswarm...${NC}"
    # Assuming gswarm is a Go package, you'd install it like this.
    # Replace with actual gswarm installation command if different (e.g., git clone, make)
    if go install github.com/gensyn-ai/gs-client-cli/gs-client@latest; then
        echo -e "${GREEN}✅ gswarm installed successfully.${NC}"
    else
        echo -e "${RED}❌ Failed to install gswarm. Please check Go installation and gswarm repository.${NC}"
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

run_gensyn_swarm_roll() {
    echo -e "${GREEN}========== STEP 4: RUN GENSYN SWARM ROLL ==========${NC}"

    # Check if required details are set
    if [ -z "$TELEGRAM_CHAT_ID" ] || [ -z "$TELEGRAM_BOT_TOKEN" ]; then
        echo -e "${RED}❌ Telegram Chat ID or Bot Token is not set. Please configure them first (Option 2).${NC}"
        return 1
    fi
    if [ -z "$EOA_WALLET_ADDRESS" ]; then
        echo -e "${RED}❌ EOA Wallet Address is not set. Please configure it first (Option 3).${NC}"
        return 1
    fi
    if ! command -v gs-client &> /dev/null; then
        echo -e "${RED}❌ gswarm (gs-client) is not installed. Please install it first (Option 1).${NC}"
        return 1
    fi

    echo -e "${CYAN}🚀 Starting Gensyn Swarm Roll with your configurations...${NC}"
    echo -e "${CYAN}Telegram Chat ID: ${TELEGRAM_CHAT_ID}${NC}"
    echo -e "${CYAN}EOA Wallet Address: ${EOA_WALLET_ADDRESS}${NC}"

    # Placeholder for the actual Gensyn Swarm Roll command
    # You will need to replace this with the real command, possibly using the variables above.
    # Example:
    # gs-client start --chat-id "$TELEGRAM_CHAT_ID" --bot-token "$TELEGRAM_BOT_TOKEN" --wallet-address "$EOA_WALLET_ADDRESS"
    echo -e "${YELLOW}Please replace this placeholder with your actual Gensyn Swarm Roll command.${NC}"
    echo -e "${YELLOW}Example: gs-client run --chat-id $TELEGRAM_CHAT_ID --bot-token $TELEGRAM_BOT_TOKEN --wallet $EOA_WALLET_ADDRESS${NC}"
    # Example command (uncomment and modify when ready)
    # gs-client run --chat-id "$TELEGRAM_CHAT_ID" --bot-token "$TELEGRAM_BOT_TOKEN" --wallet "$EOA_WALLET_ADDRESS"

    # Add a message to indicate completion or ongoing process
    echo -e "${GREEN}Gensyn Swarm Roll process initiated (or placeholder executed).${NC}"
    echo -e "${CYAN}Monitor your terminal for output from the Gensyn Swarm client.${NC}"
    return 0
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
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}4${NC}${BOLD}] ${PINK}🚀 Run Gensyn Swarm Roll         ${YELLOW}${BOLD} ║${NC}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}0${NC}${BOLD}] ${PINK}👋 Exit                           ${YELLOW}${BOLD} ║${NC}"
    echo -e "${YELLOW}${BOLD}╚═══════════════════════════════════════╝${NC}"
    echo -e "" # Add a new line for better spacing
    read -p "Choose an option [0-4]: " choice

    case $choice in
        1) install_go_gswarm; read -p "Press Enter to continue..." ;;
        2) enter_telegram_details; read -p "Press Enter to continue..." ;;
        3) enter_eoa_wallet_address; read -p "Press Enter to continue..." ;;
        4) run_gensyn_swarm_roll; read -p "Press Enter to continue..." ;;
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
