{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "breeze-enhanced";
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "BreezeEnhanced";
    rev = "bf9ea179b06c8e398f69f47d83cae81110ef0cc8"; # tag V6.5
    hash = "sha256-yfN2SKJcGhPe4/7nvbRgLyux+b9rIQlm4lJINpV20Ys=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = with kdePackages; [
    qtbase
    kdecoration
    kguiaddons
    kwindowsystem
    ki18n
    kcmutils
  ];

  meta = {
    description = "Enhanced version of the Breeze window decoration for KWin, pairs well with Kvantum themes";
    homepage = "https://github.com/tsujan/BreezeEnhanced";
    changelog = "https://github.com/tsujan/BreezeEnhanced/releases/tag/V${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
