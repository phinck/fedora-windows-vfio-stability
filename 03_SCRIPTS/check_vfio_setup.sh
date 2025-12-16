#!/usr/bin/env bash
echo "=== Fedora VFIO Quick Verification ==="

echo "[1] CPU Virtualization:"
lscpu | grep -i virtualization

echo "[2] IOMMU Kernel Parameters:"
cat /proc/cmdline | grep -E "amd_iommu|iommu=pt|vfio-pci"

echo "[3] VFIO Modules Loaded:"
lsmod | grep vfio

echo "[4] NVIDIA Devices and Drivers:"
lspci -k | grep -A3 -i nvidia

echo "[5] libvirt status:"
systemctl is-active libvirtd

echo "=== Verification Complete ==="
