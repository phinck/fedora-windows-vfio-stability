Windows hardening helpers (Steward style)

Steward_Deprovision_UWP.ps1
- Run as Administrator inside the Windows VM.
- Edit the patterns list near the top to match what you want removed.
- It applies the two-step rule:
  1) remove installed packages for current/existing users
  2) deprovision so it won’t auto-install for new profiles

Recommended workflow
1) Snapshot the VM first (SNAP_01_WIN_INSTALLED_DRIVERS_OK).
2) Run Winhance / cleanup.
3) Run this script for anything that keeps coming back (Copilot/bloat).
4) Snapshot again (SNAP_02_HARDENED_WINHANCE_DONE).
