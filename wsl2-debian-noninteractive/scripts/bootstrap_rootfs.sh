#!/usr/bin/env bash
set -euo pipefail

# bootstrap_rootfs.sh
# Estrae un rootfs Debian da un TAR e configura alcuni mount necessari per chroot
# Uso: sudo ./bootstrap_rootfs.sh path/to/debian-rootfs.tar /path/to/workdir

if [ "$EUID" -ne 0 ]; then
  echo "Questo script richiede i permessi di root (sudo)." >&2
  exit 1
fi

ROOTFS_TAR=${1:-}
WORKDIR=${2:-/tmp/debian-rootfs}

if [ -z "$ROOTFS_TAR" ]; then
  echo "Usage: $0 path/to/debian-rootfs.tar [workdir]" >&2
  exit 2
fi

mkdir -p "$WORKDIR"

echo "Estrazione $ROOTFS_TAR in $WORKDIR..."
tar -xpf "$ROOTFS_TAR" -C "$WORKDIR"

# Prepare mounts for chroot
mount --bind /dev "$WORKDIR/dev"
mount --bind /run "$WORKDIR/run" || true
mount -t proc /proc "$WORKDIR/proc"
mount -t sysfs /sys "$WORKDIR/sys"

echo "Rootfs pronto in $WORKDIR. Puoi usare create_user.sh per aggiungere utenti nello stesso rootfs via chroot."

echo "Ricordati di smontare quando finisci:"
echo "  umount $WORKDIR/proc || true"
echo "  umount $WORKDIR/sys || true"
echo "  umount $WORKDIR/run || true"
echo "  umount $WORKDIR/dev || true"
