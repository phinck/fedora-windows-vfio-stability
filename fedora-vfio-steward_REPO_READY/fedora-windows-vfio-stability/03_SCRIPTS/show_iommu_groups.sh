#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d /sys/kernel/iommu_groups ]]; then
  echo "No /sys/kernel/iommu_groups found. IOMMU may be disabled in BIOS or kernel args."
  exit 1
fi

for g in /sys/kernel/iommu_groups/*; do
  echo "IOMMU Group ${g##*/}"
  for d in "$g"/devices/*; do
    lspci -nns "${d##*/}"
  done
  echo
done
