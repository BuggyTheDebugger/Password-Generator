#!/bin/bash

# ===============================
# Memorable Password Generator
# ===============================
# Author: [CodeD-Roger]
# Description: Interactive script to generate, save, and manage secure passwords.
# Version: 1.1 (Correction for multiple password generation)

# ===============================
# Global Variables
# ===============================
LOG_FILE="./password_manager.log"
DICT_FILE="./dictionary.txt"
PASSWORD_FILE="./passwords.gpg"
REQUIRED_TOOLS=("gpg" "curl")

# Default Configuration
MIN_LENGTH=8
MAX_LENGTH=16
INCLUDE_UPPER=true
INCLUDE_NUMBERS=true
INCLUDE_SPECIAL=true

# ===============================
# Common Functions
# ===============================

# Logging actions
function log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Checking and installing dependencies
function check_and_install_dependencies() {
    log_action "[+] Checking dependencies..."
    for tool in "${REQUIRED_TOOLS[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            log_action "[-] $tool not found. Installing..."
            if command -v apt &> /dev/null; then
                apt-get update && apt-get install -y "$tool"
            elif command -v yum &> /dev/null; then
                yum install -y "$tool"
            else
                log_action "[-] Unable to install $tool: unsupported package manager."
                exit 1
            fi
        else
            log_action "[+] $tool is already installed."
        fi
    done
}

# Initializing the dictionary
function initialize_dictionary() {
    if [[ ! -f "$DICT_FILE" ]]; then
        log_action "[+] Downloading dictionary..."
        curl -s https://raw.githubusercontent.com/dwyl/english-words/master/words.txt -o "$DICT_FILE"
        log_action "[+] Dictionary saved to $DICT_FILE."
    fi
}

# Return to main menu
function return_to_menu() {
    echo
    read -p "[?] Press Enter to return to the main menu..." key
    main_menu
}

# ===============================
# Password Generation
# ===============================

# Generate a unique password
function generate_password() {
    local LENGTH=$1
    PASSWORD=""
    while [[ ${#PASSWORD} -lt $LENGTH ]]; do
        WORD=$(shuf -n 1 "$DICT_FILE")
        PASSWORD+="$WORD"
    done
    PASSWORD=${PASSWORD:0:$LENGTH}

    # Add special characters, uppercase, numbers if configured
    [[ "$INCLUDE_UPPER" == true ]] && PASSWORD=$(echo "$PASSWORD" | sed 's/^./\U&/')
    [[ "$INCLUDE_NUMBERS" == true ]] && PASSWORD+="$(shuf -i 0-9 -n 1)"
    [[ "$INCLUDE_SPECIAL" == true ]] && PASSWORD+="$(echo '!@#$%^&*' | fold -w1 | shuf | head -n1)"

    echo "$PASSWORD"
}

# Generate multiple passwords
function generate_multiple_passwords() {
    read -p "[?] Number of passwords to generate: " COUNT
    [[ -z "$COUNT" || "$COUNT" -le 0 ]] && COUNT=1
    read -p "[?] Desired length (min: $MIN_LENGTH, max: $MAX_LENGTH): " LENGTH
    [[ -z "$LENGTH" ]] && LENGTH=$MIN_LENGTH
    if (( LENGTH < MIN_LENGTH || LENGTH > MAX_LENGTH )); then
        echo "[-] Invalid length. Using default length: $MIN_LENGTH."
        LENGTH=$MIN_LENGTH
    fi

    echo "[+] Generated passwords:"
    for (( i = 1; i <= COUNT; i++ )); do
        PASSWORD=$(generate_password "$LENGTH")
        echo "  $i. $PASSWORD"
    done
    return_to_menu
}

# ===============================
# Save and Manage Passwords
# ===============================

# Save a password
function save_password() {
    read -p "[?] Enter the password to save: " PASSWORD
    read -p "[?] Enter a description (e.g., Email account): " DESCRIPTION
    echo "$DESCRIPTION : $PASSWORD" | gpg --symmetric --cipher-algo AES256 --output "$PASSWORD_FILE"
    log_action "[+] Password saved to $PASSWORD_FILE."
    return_to_menu
}

# View saved passwords
function view_passwords() {
    if [[ ! -f "$PASSWORD_FILE" ]]; then
        echo "[-] No saved passwords found."
    else
        gpg --decrypt "$PASSWORD_FILE" 2>/dev/null
    fi
    return_to_menu
}

# ===============================
# Training Mode
# ===============================

# Training mode
function training_mode() {
    PASSWORD=$(generate_password $MIN_LENGTH)
    echo "[+] Memorize this password: $PASSWORD"
    sleep 5
    clear
    read -p "[?] Retype the password: " INPUT
    if [[ "$INPUT" == "$PASSWORD" ]]; then
        echo "[+] Great! Your memory is excellent!"
    else
        echo "[-] Incorrect. The password was: $PASSWORD"
    fi
    return_to_menu
}

# ===============================
# Configuration
# ===============================

# Configure rules
function configure_rules() {
    read -p "[?] Minimum password length ($MIN_LENGTH): " NEW_MIN_LENGTH
    read -p "[?] Maximum password length ($MAX_LENGTH): " NEW_MAX_LENGTH
    read -p "[?] Include uppercase letters? (y/n): " INCLUDE_UPPER
    read -p "[?] Include numbers? (y/n): " INCLUDE_NUMBERS
    read -p "[?] Include special characters? (y/n): " INCLUDE_SPECIAL

    MIN_LENGTH=${NEW_MIN_LENGTH:-$MIN_LENGTH}
    MAX_LENGTH=${NEW_MAX_LENGTH:-$MAX_LENGTH}
    INCLUDE_UPPER=$( [[ "${INCLUDE_UPPER,,}" == "y" ]] && echo true || echo false )
    INCLUDE_NUMBERS=$( [[ "${INCLUDE_NUMBERS,,}" == "y" ]] && echo true || echo false )
    INCLUDE_SPECIAL=$( [[ "${INCLUDE_SPECIAL,,}" == "y" ]] && echo true || echo false )

    echo "[+] Configuration updated."
    return_to_menu
}

# ===============================
# Main Menu
# ===============================

function main_menu() {
    clear
    echo "========================="
    echo " PASSWORD GENERATOR"
    echo "========================="
    echo "1. Generate a unique password"
    echo "2. Generate multiple passwords"
    echo "3. Save a password"
    echo "4. View saved passwords"
    echo "5. Training mode"
    echo "6. Configure rules"
    echo "0. Quit"
    read -p "Choose an option: " OPTION

    case $OPTION in
        1) 
            read -p "[?] Desired length (min: $MIN_LENGTH, max: $MAX_LENGTH): " LENGTH
            PASSWORD=$(generate_password "$LENGTH")
            echo "[+] Generated password: $PASSWORD"
            return_to_menu
            ;;
        2) generate_multiple_passwords ;;
        3) save_password ;;
        4) view_passwords ;;
        5) training_mode ;;
        6) configure_rules ;;
        0) exit 0 ;;
        *) echo "[-] Invalid option." ;;
    esac
}

# ===============================
# Script Execution
# ===============================
check_and_install_dependencies
initialize_dictionary
main_menu
