{pkgs, apple-fonts, ... }: 
{
  fonts.packages = with pkgs; [
    noto-fonts noto-fonts-cjk-sans noto-fonts-color-emoji
    nerd-fonts.fira-code nerd-fonts.jetbrains-mono
    apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-pro
    apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-mono
    apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.ny
  ];
}
