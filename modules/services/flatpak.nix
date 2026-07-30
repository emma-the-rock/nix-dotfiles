{
  services.flatpak = {
    enable = true;

    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    packages = [
      "com.obsproject.Studio"
      "com.obsproject.Studio.Plugin.OBSVkCapture"
      "com.obsproject.Studio.Plugin.VerticalCanvas"
      "com.obsproject.Studio.Plugin.AitumMultistream"
      "com.obsproject.Studio.Plugin.CompositeBlur"
      "com.obsproject.Studio.Plugin.OBSPWVideo"
      "org.freedesktop.Platform.VulkanLayer.OBSVkCapture//25.08"
      "com.valvesoftware.Steam"
      "me.amankhanna.opendeck"
    ];
  };
}
