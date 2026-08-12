let
  # Emma's personal SSH keys (same ones authorized in modules/system/users.nix),
  # so secrets can be edited/re-keyed from his own workstations.
  emma-main-pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8vfwM5g9RJXqHtqTgNqsYg9SxSm+UMvFqTjBoAsLJ6 emmatherock@MAIN-PC";
  emma-s21-plus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIpTslcK0yQ6k+h8foNl17wVRyJUfEGzq7f1h3014WNB s21 plus";
  emma-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEUCpjAuJobymPPAoPjLdL1eD6g4v6wrquu3cyHP22Wj emmatherock@NixOS";

  # Host SSH host keys, used by agenix at runtime to decrypt (via the default
  # age.identityPaths, which points at services.openssh host keys).
  miku-homelab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH7zsQdzX7RHRd2plwrTKJR89uwR2YfzBm1n+HkcYEbb root@NixOS";

  vps = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDh8+hpWkGLRszFI4TC1/YHB8IiSdM0UUOsWbOwXPLn6 root@vps";

  admins = [ emma-main-pc emma-s21-plus emma-nixos ];
in
{
  "miku-homelab-wg.age".publicKeys = admins ++ [ miku-homelab ];
  "vps-wg.age".publicKeys = admins ++ [ vps ];
}
