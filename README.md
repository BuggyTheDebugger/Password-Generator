# Memorable Password Generator

## Overview

This is an interactive Bash script designed to generate secure and memorable passwords, manage password storage securely with GPG encryption, and provide a training mode to improve password memorization skills. It is ideal for system administrators, developers, and individuals focused on maintaining strong security practices.

## Features

- **Password Generation**:
  - Generate single or multiple passwords.
  - Configurable length and inclusion of uppercase letters, numbers, and special characters.
- **Password Management**:
  - Save passwords securely using GPG encryption.
  - Retrieve and view saved passwords with decryption.
- **Training Mode**:
  - Practice memorizing passwords with an interactive tool.
- **Configuration**:
  - Adjust rules for password generation, including length and character sets.
- **Logging**:
  - Actions are logged for audit purposes.

## Requirements

- **Operating System**: Linux-based distributions (e.g., Ubuntu, Debian).
- **Privileges**: Root or sudo access for package installation.
- **Dependencies**:
  - `gpg`: For encrypting and decrypting passwords.
  - `curl`: For downloading the word dictionary.

## Installation
```bash
git clone https://github.com/CodeD-Roger/Password-Generator.git
cd Password-Generator
chmod +x password_generator
sudo ./password_generator
```

## Usage
```bash
sudo ./password_generator
