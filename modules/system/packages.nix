{pkgs, ... }: 
{
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    ethtool
    fish
    rocmPackages.rocm-smi
    btrfs-progs
    distrobox
    steam-run
  ];
}
