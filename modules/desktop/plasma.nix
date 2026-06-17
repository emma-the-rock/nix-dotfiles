{ ... }: 
{
  services.desktopManager.plasma6.enable = true;
  services.displayManager = {
    plasma-login-manager.enable = true;
    autoLogin = { enable = true; user = "emmatherock"; };
  };
  security.pam.services.login.enableKwallet = true;

}
