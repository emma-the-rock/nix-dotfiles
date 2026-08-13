{ lib, ... }:
{
  options.myHomeProfile.extraPrograms = lib.mkOption {
    type = lib.types.listOf lib.types.path;
    default = [ ];
    description = "Extra Home Manager modules to import for this user, on top of the core profile.";
  };
}
