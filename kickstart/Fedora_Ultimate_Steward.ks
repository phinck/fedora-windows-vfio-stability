# Fedora Ultimate Steward Kickstart
install
graphical
reboot

lang en_US.UTF-8
keyboard us
timezone America/Denver --utc

network --bootproto=dhcp --device=link --activate

selinux --enforcing
firewall --enabled

rootpw --lock
user --name=steward --groups=wheel,libvirt --password=changeme --plaintext

bootloader --location=mbr --timeout=5
autopart --type=btrfs

%packages
@^workstation-product-environment
@virtualization
virt-manager
%end

%post
systemctl enable libvirtd
systemctl enable firewalld
%end