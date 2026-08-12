{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "vfs objects" = "acl_xattr";
        "map acl inherit" = "yes";
        "store dos attributes" = "yes";
      };
      mikufanclub = {
        path = "/mnt/data/mikufanclub";
        writable = "yes";
        "valid users" = "mikushare emmatherock";
        "force group" = "mikushare-group";
        "create mask" = "0660";
        "directory mask" = "0770";
      };
      data-private = {
        path = "/mnt/data";
        writable = "yes";
        "valid users" = "emmatherock";
        "browseable" = "yes";
      };
    };
  };
}
