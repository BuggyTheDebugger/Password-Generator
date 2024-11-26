# Password Generator Script

## Description
This script is a versatile password generator designed to help users create, manage, and secure memorable yet robust passwords. It features options for customization, password encryption, and even a training mode to improve password memorization skills.

## Features
- Generate single or multiple passwords with configurable length and complexity.
- Save and encrypt passwords locally using GPG (AES256 encryption).
- Review saved passwords securely.
- Customize password rules (length, inclusion of uppercase, numbers, and special characters).
- Practice memorizing passwords with the training mode.
- Automatically installs required dependencies for seamless execution.

## Requirements
- A Linux environment with the following tools installed:
  - `gpg`
  - `curl`
- An active internet connection (required to download the dictionary on the first run).

 ## Installation :
 - git clone https://github.com/BuggyTheDebugger/password-generator
 - cd password-generator
 - chmod +x password_generator.sh
 - sudo ./password_generator.sh

## Usage
1. **Run the script:**
   ```bash
   sudo  ./generateur-mots-de-passes.txt

## Notes

- Ensure you have the necessary permissions to execute the script (chmod +x ).
- To decrypt saved passwords, you will need the same GPG setup as used during encryption.
