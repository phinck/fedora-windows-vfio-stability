[README.md](https://github.com/user-attachments/files/24199031/README.md)
# Fedora VFIO Steward

## Overview

This repository documents a stability-first design for running Windows inside a KVM/libvirt
virtual machine with full GPU passthrough on a Fedora host.

The guiding principle is stewardship: the Fedora host must always boot, remain predictable,
and be recoverable. Performance optimizations are secondary to correctness, isolation, and
clear recovery paths.

This repository is shared for technical review and feedback on the soundness of the design.

---

## System Goals

- Fedora acts as a stable, always-booting host
- Windows runs fully contained inside a virtual machine
- Dual-GPU architecture:
  - Host GPU is never passed through
  - Passthrough GPU is dedicated to the VM
- Conservative defaults prioritized over performance tuning
- All changes are reversible
- No point-of-no-return steps

---

## Non-Goals

The following are intentional exclusions:

- CPU pinning or core isolation
- ACS override patches
- Experimental kernels
- Scheduler tuning
- Benchmark or latency optimization work

---

## Documentation

Primary design document:

docs/DESIGN_FULL_v5.docx

This document contains the full system design, hardware assumptions, BIOS configuration,
tradeoffs, and recovery discipline.

Companion execution checklist:

docs/GUIDE_EXECUTION_CHECKLIST.txt

This checklist summarizes order-of-operations and is intended as a companion to the full
design document.

---

## Repository Structure

fedora-vfio-steward/
├── README.md
├── docs/
│   ├── DESIGN_FULL_v5.docx
│   └── GUIDE_EXECUTION_CHECKLIST.txt
└── kickstart/
    └── Fedora_Ultimate_Steward.ks
