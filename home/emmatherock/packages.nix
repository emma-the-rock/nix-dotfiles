{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # --- Base y Terminal ---
    vim
    fastfetch
    (btop.override { cudaSupport = false; rocmSupport = true; })
    nvtopPackages.full
  ];
}
