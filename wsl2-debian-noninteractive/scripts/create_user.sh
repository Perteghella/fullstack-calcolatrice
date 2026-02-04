#!/usr/bin/env bash
set -euo pipefail

# create_user.sh
# Crea un utente all'interno di un rootfs estratto (chroot) e imposta password non-interattiva
# Uso: sudo ./create_user.sh /path/to/rootfs username 'PA$$w0rd'

if [ "$EUID" -ne 0 ]; then
  echo "Questo script richiede i permessi di root (sudo)." >&2
  exit 1
fi

ROOTFS=${1:-}
USER=${2:-user}
PASS=${3:-PA\$\$w0rd}

if [ -z "$ROOTFS" ]; then
  echo "Usage: $0 /path/to/rootfs username password" >&2
  exit 2
fi

if [ ! -d "$ROOTFS" ]; then
  echo "Cartella rootfs non trovata: $ROOTFS" >&2
  exit 3
fi

# Ensure required mounts are present (this is tolerant if already bind-mounted)
mount --bind /dev "$ROOTFS/dev" || true
mount --bind /run "$ROOTFS/run" || true
mount -t proc /proc "$ROOTFS/proc" || true
mount -t sysfs /sys "$ROOTFS/sys" || true

chroot "$ROOTFS" /usr/sbin/useradd -m -s /bin/bash "$USER" || true
# Set password non-interattiva
chroot "$ROOTFS" /bin/bash -lc "echo '$USER:$PASS' | chpasswd"
# Install sudo and add to group sudo
chroot "$ROOTFS" /bin/bash -lc "apt-get update && apt-get install -y sudo || true"
chroot "$ROOTFS" /usr/sbin/usermod -aG sudo "$USER" || true

echo "Utente $USER creato e aggiunto a sudo (password impostata)."
