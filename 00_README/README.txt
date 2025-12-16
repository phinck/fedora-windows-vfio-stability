Fedora TRX40 Ultimate Steward Package (v5 VERIFIED)

What this package is:
- A single authoritative step-by-step guide for Fedora host + Windows VM with RTX 3090 GPU passthrough
  on TRX40 AORUS MASTER (rev 1.0), designed to be followed in order.
- Appendices for BIOS navigation, first-boot expectations, and failure recovery.
- A host-side verification script to confirm VFIO/IOMMU/libvirt state.

Files & intended use:
01_GUIDE/Fedora_Windows_VM_Ultimate_Steward_Guide_v5_FULL.docx
  - The ONLY document you follow end-to-end. Baseline-first, with elastic CPU + elastic RAM strategy included.

02_APPENDICES/Fedora_Windows_VM_Appendix_Pack.pdf
  - Quick reference pack (BIOS cheat + first boot expectations + recovery quick reference).

02_APPENDICES/TRX40_AORUS_MASTER_BIOS_Cheat_Sheet.pdf
  - Printable one-page BIOS menu path sheet.

02_APPENDICES/Fedora_Windows_VM_Failure_Recovery_Checklist.pdf
  - Troubleshooting checklist (use when something breaks).

03_SCRIPTS/check_vfio_setup.sh
  - Run on the Fedora host: chmod +x check_vfio_setup.sh && ./check_vfio_setup.sh

Operational checkpoints (do not skip):
1) After BIOS: Fedora boots using GTX 1080 (host GPU).
2) After VFIO setup + reboot: RTX 3090 shows 'Kernel driver in use: vfio-pci' on the host.
3) VM creation: OVMF/Q35, VirtIO disk+NIC, RTX 3090 VGA+Audio passed through.
4) Windows install: VirtIO storage driver loaded if disk not visible; VirtIO guest tools installed.
5) After driver install: snapshot the VM; only then do hardening and updates.


New in v5.1 addendum (added files; original untouched):
- 01_GUIDE/Fedora_Windows_VM_Ultimate_Steward_Guide_v5_1_FULL.docx
  - Same guide, with added beginner step-by-step VM creation clicks, Fedora grubby note, IOMMU group sanity check, and expanded Windows hardening section.
- 04_WINDOWS_HARDENING/Steward_Deprovision_UWP.ps1
  - A reusable PowerShell helper to remove + deprovision UWP apps (Copilot/bloat) using the two-step pattern.
- 03_SCRIPTS/show_iommu_groups.sh
  - Prints IOMMU groups in a readable way (sanity check before binding vfio-pci).
