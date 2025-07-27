#!/usr/bin/env bash
###########################
# Written by: Yair Kochavi
# Date: 27/07/2025
# Purpose: Install deploymetn and mount NFS share for k3s
# License: MIT
# Usage: sudo ./deploy-nfs.sh
# Dependencies: nfs-kernel-server
# Requirements: Debian-based system
# Version: 0.0.3
###########################

LOGFILE=/var/log/nfs-setup.log
NFSDIR=/mnt/tank/k3s-data
NULL=/dev/null
EXPXONF=/etc/exports

# --- Logging functions ---
log() {
    level="$1"
    shift
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $*" | tee -a "$LOGFILE"
}

info()    { log INFO "$@"; }
success() { log SUCCESS "$@"; }
warn()    { log WARN "$@"; }
error()   { log ERROR "$@"; }
task()    { echo -e "\n==> $*" | tee -a "$LOGFILE"; }

# --- Root check ---
check_root() {
    [[ "$EUID" -eq 0 ]]
}

main() {
    echo "📦 Starting NFS Installation Script"
    info "Script started"
    info "Logging to $LOGFILE"

    task "Checking for root privileges"
    if ! check_root; then
        error "Must be run as root"
        exit 1
    fi
    success "Root privileges confirmed"

    task "Checking if script is run with sudo"
    if [[ -z "$SUDO_USER" ]]; then
        error "Please run the script using sudo, not as root directly."
        exit 1
    fi
    success "Running with sudo as $SUDO_USER"

    task "Checking if system is Debian"
    if ! grep -qi "debian" /etc/os-release; then
        error "This script is designed for Debian-based systems only."
        exit 1
    fi
    success "Debian system confirmed"

    task "Installing nfs-kernel-server"
    if apt-get update >> "$LOGFILE" 2>&1 && apt-get install -y nfs-kernel-server >> "$LOGFILE" 2>&1; then
        success "NFS server installed successfully"
    else
        error "Failed to install NFS server"
        exit 1
    fi

    task "Creating shared directory at $NFSFILE"
    mkdir -p "$NFSFILE"
    success "Directory created at $NFSFILE"

    task "Creating index.html file"
    echo "NFS StorageClass To Container" > "$NFSFILE/index.html"
    success "index.html created"

    task "Exporting NFS share"
    if ! grep -q "$NFSFILE" "$EXPFILE"; then
        echo "$NFSFILE *(rw,sync,no_subtree_check,no_root_squash)" >> "$EXPFILE"
        success "Added export to $EXPFILE"
    else
        info "Export already exists in $EXPFILE"
    fi
    exportfs -rav >> "$LOGFILE" 2>&1
    success "Exports refreshed"

    task "Restarting nfs-kernel-server"
    systemctl restart nfs-kernel-server >> "$LOGFILE" 2>&1
    success "NFS service restarted"

    success "✅ NFS setup complete!"
}

main "$@"
