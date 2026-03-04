#!/bin/bash

# ==============================
# Color Definitions
# ==============================
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[97m"
BOLD="\e[1m"
RESET="\e[0m"

echo -e "${CYAN}${BOLD}"
echo "=============================================="
echo "     Ubuntu Virtualization Auto Installer     "
echo "=============================================="
echo -e "${RESET}"

# Root check
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Please run this script with sudo.${RESET}"
   exit 1
fi

# Update system
echo -e "${BLUE}Updating system...${RESET}"
apt update -y && apt upgrade -y

# Install packages
echo -e "${BLUE}Installing virtualization packages...${RESET}"
apt install -y qemu-kvm libvirt-daemon-system libvirt-clients \
bridge-utils virt-manager virtinst libguestfs-tools cpu-checker

# Enable libvirt
echo -e "${BLUE}Enabling libvirt service...${RESET}"
systemctl enable libvirtd
systemctl start libvirtd

# Add user to groups
USER_NAME=$(logname)
echo -e "${BLUE}Adding ${USER_NAME} to libvirt and kvm groups...${RESET}"
usermod -aG libvirt $USER_NAME
usermod -aG kvm $USER_NAME

# Check virtualization support
echo -e "${MAGENTA}Checking CPU virtualization support...${RESET}"
VIRT_CHECK=$(egrep -c '(vmx|svm)' /proc/cpuinfo)

if [ "$VIRT_CHECK" -gt 0 ]; then
    echo -e "${GREEN}Virtualization is supported by your CPU.${RESET}"
else
    echo -e "${RED}Virtualization NOT supported or disabled in BIOS.${RESET}"
fi

# Check KVM
echo -e "${MAGENTA}Checking KVM acceleration...${RESET}"
kvm-ok

echo -e "${GREEN}${BOLD}"
echo "=============================================="
echo "     Installation Completed Successfully!     "
echo "=============================================="
echo -e "${RESET}"

echo -e "${YELLOW}IMPORTANT:${RESET} Please log out and log back in (or reboot) for group changes to apply."