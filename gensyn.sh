#!/bin/bash

# Color codes
YELLOW='\033[1;33m'     # Bold Yellow
BOLD='\033[1m'          # General Bold
CYAN='\033[1;36m'       # Bold Cyan
GREEN='\033[1;32m'      # Bold Green
PINK='\033[38;5;198m'   # Deep Pink (Using 256-color code for specific shade)
RED='\033[1;31m'        # Bold Red
MAGENTA='\033[1;35m'    # Bold Magenta
NC='\033[0m'            # No Color

# --- Global Variables for Configuration ---
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
        fi # This `fi` closes the inner `if` statement correctly.
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz
        rm go1.22.2.linux-amd64.tar.gz
        echo -e "${GREEN}Go installed successfully.${NC}"
    else
        echo -e "${GREEN}✅ Go is already installed.${NC}"
    fi # This `fi` closes the outer `if` statement correctly.

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

enter_telegram_and_wallet_details() {
    echo -e "${GREEN}========== STEP 2: ENTER TELEGRAM & WALLET DETAILS ==========${NC}"

    echo -e "${MAGENTA}💡 আপনার টেলিগ্রাম বট টোকেন @BotFather থেকে পান।${NC}"
    read -e -p "${PINK}Enter your Telegram Bot Token (e.g., 12345:ABC-DEF): ${NC}" BOT_TOKEN_INPUT

    echo -e "${MAGENTA}💡 আপনার চ্যাট আইডি @userinfobot থেকে পান।${NC}"
    read -e -p "${PINK}Enter your Telegram Chat ID (e.g., 123456789): ${NC}" CHAT_ID_INPUT

    echo -e "${MAGENTA}💡 আপনার EOA Wallet Address এখান থেকে পান: https://gensyn-tracker.shair.live/${NC}"
    read -e -p "${PINK}Enter your EOA Wallet Address (e.g., 0x...): ${NC}" EOA_ADDRESS_INPUT

    if [[ -z "$BOT_TOKEN_INPUT" || -z "$CHAT_ID_INPUT" ]]; then
        echo -e "${RED}❌ Bot Token বা Chat ID খালি রাখা যাবে না! আবার চেষ্টা করুন।${NC}"
        return 1
    fi

    if [[ ! "$EOA_ADDRESS_INPUT" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
        echo -e "${RED}❌ EOA Wallet Address এর ফরম্যাট সঠিক নয়। এটি '0x' দিয়ে শুরু হবে এবং ৪২ অক্ষরের হবে।${NC}"
        return 1
    fi

    TELEGRAM_BOT_TOKEN="$BOT_TOKEN_INPUT"
    TELEGRAM_CHAT_ID="$CHAT_ID_INPUT"
    EOA_WALLET_ADDRESS="$EOA_ADDRESS_INPUT"

    echo -e "${GREEN}✅ বিবরণ সফলভাবে সংরক্ষণ করা হয়েছে! ✨${NC}"
    echo -e "${CYAN}বট টোকেন: ${TELEGRAM_BOT_TOKEN:0:5}****${NC}"
    echo -e "${CYAN}চ্যাট আইডি: ${TELEGRAM_CHAT_ID}${NC}"
    echo -e "${CYAN}ওয়ালেট ঠিকানা: ${EOA_WALLET_ADDRESS}${NC}"
    return 0
}

go_discord_for_roll() {
    echo -e "${GREEN}========== STEP 3: GO DISCORD FOR ROLL ==========${NC}"
    echo -e "${CYAN}গুরুত্বপূর্ণ আপডেট এবং কমিউনিটি সাপোর্টের জন্য Gensyn Discord এ যোগ দিন:${NC}"
    echo -e "${PINK}🔗 ডিসকর্ড ইনভাইট লিঙ্ক: https://discord.com/invite/gensyn ${NC}"
    echo -e "${CYAN}অনুগ্রহ করে আপনার ওয়েব ব্রাউজারে এই লিঙ্কটি খুলুন।${NC}"
}


run_gswarm() {
    echo -e "${GREEN}========== STEP 4: RUN GSWARM ==========${NC}"

    if ! command -v gswarm &> /dev/null; then
        echo -e "${RED}❌ gswarm এক্সিকিউটেবল খুঁজে পাওয়া যায়নি। অনুগ্রহ করে প্রথমে এটি ইনস্টল করুন (অপশন ১)।${NC}"
        echo -e "${RED}নিশ্চিত করুন যে Go পাথ সঠিকভাবে সেট করা হয়েছে এবং আপনি আপনার .bashrc সোর্স করেছেন।${NC}"
        return 1
    fi

    if [ -z "$TELEGRAM_CHAT_ID" ] || [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$EOA_WALLET_ADDRESS" ]; then
        echo -e "${RED}❌ টেলিগ্রাম বা EOA ওয়ালেট ঠিকানার বিবরণ এই স্ক্রিপ্টের সেশনে সেট করা নেই।${NC}"
        echo -e "${RED}অনুগ্রহ করে প্রথমে টেলিগ্রাম ও ওয়ালেটের বিবরণ লিখুন (অপশন ২)।${NC}"
        return 1
    fi

    echo -e "${CYAN}🚀 আপনার কনফিগার করা বিবরণ সহ gswarm শুরু হচ্ছে...${NC}"
    echo -e "${CYAN}বট টোকেন (আংশিক): ${TELEGRAM_BOT_TOKEN:0:5}****${NC}"
    echo -e "${CYAN}চ্যাট আইডি: ${TELEGRAM_CHAT_ID}${NC}"
    echo -e "${CYAN}ওয়ালেট ঠিকানা: ${EOA_WALLET_ADDRESS}${NC}"

    gswarm --telegram-chat-id "$TELEGRAM_CHAT_ID" --telegram-bot-token "$TELEGRAM_BOT_TOKEN" --eoa-address "$EOA_WALLET_ADDRESS"

    echo -e "${GREEN}gswarm কমান্ড এক্সিকিউট হয়েছে। স্ট্যাটাসের জন্য এর আউটপুট মনিটর করুন।${NC}"
    echo -e "${CYAN}দ্রষ্টব্য: এই স্ক্রিপ্টটি শুধুমাত্র gswarm শুরু করে। এটি অনির্দিষ্টকালের জন্য চলতে পারে।${NC}"
}

# --- Main loop for the menu ---
while true; do
    print_header # Display the main header
    echo -e "${YELLOW}${BOLD}╔═══════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}${BOLD}║      🔵 GENSYN SWARM ROLL MENU 🔵    ║${NC}"
    echo -e "${YELLOW}${BOLD}╠═══════════════════════════════════════╣${NC}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}1${NC}${BOLD}] ${PINK}📦 Install Go & gswarm            ${YELLOW}${BOLD}  ║${NC}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}2${NC}${BOLD}] ${PINK}💬 Enter Telegram & Wallet Details${YELLOW}${BOLD} ║${NC}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}3${NC}${BOLD}] ${PINK}🗣️ Go Discord for Roll           ${YELLOW}${BOLD} ║${NC}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}4${NC}${BOLD}] ${PINK}🚀 Run gswarm                    ${YELLOW}${BOLD} ║${NC}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}0${NC}${BOLD}] ${PINK}👋 Exit                           ${YELLOW}${BOLD} ║${NC}"
    echo -e "${YELLOW}${BOLD}╚═══════════════════════════════════════╝${NC}"
    echo -e "" # Add a new line for better spacing
    read -p "Choose an option [0-4]: " choice

    case $choice in
        1) install_go_gswarm; read -p "Press Enter to continue..." ;;
        2) enter_telegram_and_wallet_details; read -p "Press Enter to continue..." ;;
        3) go_discord_for_roll; read -p "Press Enter to continue..." ;;
        4) run_gswarm; read -p "Press Enter to continue..." ;;
        0)
            echo -e "🚪 এক্সিট হচ্ছে... বাই! 👋"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ ভুল অপশন! অনুগ্রহ করে ০ থেকে ৪ এর মধ্যে একটি সংখ্যা দিন।${NC}"
            sleep 1
            ;;
    esac

done
