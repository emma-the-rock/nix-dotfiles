{ pkgs, ... }:
{
  programs.btop.package = pkgs.btop.override { cudaSupport = false; rocmSupport = true; };

  home.packages = with pkgs; [
    # --- Base y Terminal ---
    vim
    fastfetch
    nvtopPackages.full
  ];
}
