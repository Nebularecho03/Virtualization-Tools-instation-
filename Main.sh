get_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
        if [ "$ID" = "ubuntu" ]; then
            echo "ubuntu based distro"
            /usr/bin/bash ubuntu.sh
        elif [ "$ID" = "debian" ]; then
            echo "debian based distro"
            /usr/bin/bash debian.sh
        elif [ "$ID" = "arch" ]; then
            echo "arch based distro"
            /usr/bin/bash Arch.sh
        elif [[ "$ID" == "rhel" || "$ID" == "fedora" ]]; then
            echo "redhat_fedora based distro"
            /usr/bin/bash RED_HAT_ENTERPRICE_and_Fedora.sh
        else
            echo "unknown"
            echo "error: unsupported distribution"
            exit 1
        fi
    else
        echo "unknown"
    fi
}



apply_changes_and_reboot() {
    echo "Please reboot your system to apply changes and start using virtualization features."
    read -p "Do you want to reboot now? (y/n): " REBOOT_CHOICE
    if [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]]; then
        systemctl reboot -i
    else
        read -p "Press Enter to reboot now or Ctrl+C to exit..."
        systemctl reboot -i
    fi
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
       echo -e "${RED}❌ Please run this script with sudo or as root.${RESET}"
       exit 1
    fi
}   
main() {
    check_root  
    get_distro
    apply_changes_and_reboot
}   
main "$@"
