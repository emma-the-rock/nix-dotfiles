let
  # Emma's personal SSH keys (same ones authorized in modules/system/users.nix),
  # so secrets can be edited/re-keyed from her own workstations.
  emma-main-pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8vfwM5g9RJXqHtqTgNqsYg9SxSm+UMvFqTjBoAsLJ6 emmatherock@MAIN-PC";
  emma-s21-plus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIpTslcK0yQ6k+h8foNl17wVRyJUfEGzq7f1h3014WNB s21 plus";

  # Host SSH host keys, used by agenix at runtime to decrypt (via the default
  # age.identityPaths, which points at services.openssh host keys).
  miku-homelab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH7zsQdzX7RHRd2plwrTKJR89uwR2YfzBm1n+HkcYEbb root@NixOS";

  # TODO: replace with the real vps SSH host key once the host is installed
  # (e.g. via `ssh-keyscan` or by reading /etc/ssh/ssh_host_ed25519_key.pub on
  # the vps itself), then re-key any vps secrets that were encrypted without it.
  vps = "ssh-ed25519 REPLACE_ME_AFTER_VPS_INSTALL";

  admins = [ emma-main-pc emma-s21-plus ];
in
{
  "miku-homelab-wg.age".publicKeys = admins ++ [ miku-homelab ];
}
