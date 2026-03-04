#!/bin/bash

# ==============================
# 🎨 Color Setup
# ==============================
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

clear
echo -e "${CYAN}${BOLD}"
echo "=================================================="
echo "         Arch Linux Virtualization Installer     "
echo "=================================================="
echo -e "${RESET}"

# Root check
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}❌ Please run this script with sudo or as root.${RESET}"
   exit 1
fi

# Update System
echo -e "${BLUE}🔄 Updating system...${RESET}"
pacman -Syu --noconfirm

# Install Virtualization Packages
echo -e "${BLUE}📥 Installing virtualization packages...${RESET}"
pacman -S --noconfirm qemu-full libvirt virt-manager virt-install \
dnsmasq bridge-utils edk2-ovmf vde2 openbsd-netcat

# Enable and Start libvirt
echo -e "${BLUE}⚙ Enabling libvirt service...${RESET}"
systemctl enable --now libvirtd

# Add User to Required Groups
USER_NAME=$(logname)
echo -e "${BLUE}👤 Adding ${USER_NAME} to libvirt and kvm groups...${RESET}"
usermod -aG libvirt $USER_NAME
usermod -aG kvm $USER_NAME

# Check CPU Virtualization
echo -e "${MAGENTA}🧠 Checking CPU virtualization support...${RESET}"
VIRT_CHECK=$(egrep -c '(vmx|svm)' /proc/cpuinfo)

if [ "$VIRT_CHECK" -gt 0 ]; then
    echo -e "${GREEN}✔ CPU supports virtualization.${RESET}"
else
    echo -e "${RED}❌ Virtualization not supported or disabled in BIOS.${RESET}"
fi

# Check KVM Modules
echo -e "${MAGENTA}🚀 Checking loaded KVM modules...${RESET}"
lsmod | grep kvm

echo -e "${GREEN}${BOLD}"
echo "=================================================="
echo "        ✅ Installation Completed Successfully     "
echo "=================================================="
echo -e "${RESET}"

echo -e "${YELLOW}⚠ IMPORTANT: Log out and log back in (or reboot) for group changes to apply.${RESET}"