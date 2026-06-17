{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # --- Base y Terminal ---
    vim
    fastfetch
    (btop.override { cudaSupport = false; rocmSupport = true; })
    nvtopPackages.full
    gemini-cli
    inputs.sidra.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
