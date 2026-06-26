{pkgs, ...}:

let 
  containerUser = "iris-development";
  containerUserHome = "/var/home/${containerUser}";
  containerUid = 64312;
in {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      (pkgs.callPackage ./pkgs/vscode-intersystems-objectscript.nix { })
      (pkgs.callPackage ./pkgs/vscode-intersystems-servermanager.nix { })
      (pkgs.callPackage ./pkgs/vscode-intersystems-language-server.nix { })
    ];
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers.iris-development = {
      autoStart = false;
      podman = {
        user = containerUser;
      };
      hostname = "iris-development";
      image = "intersystems/iris-community:latest-em";
      ports = [
        "127.0.0.1:52773:52773"
        "127.0.0.1:1972:1972"
      ];
      extraOptions = [ "--userns=keep-id" ];
      volumes = [
        "${containerUserHome}/iris-data:/usr/irissys/mgr"
      ];
    };
  };

  users.users."${containerUser}" = {
    isSystemUser = true;
    uid = containerUid;
    group = containerUser;
    createHome = true;
    home = containerUserHome;
    linger = true;
    
    # Ermöglicht Rootless Podman das Mapping von UIDs innerhalb des Containers
    autoSubUidGidRange = true;
  };
  users.groups."${containerUser}" = {
    gid = containerUid;
  };
}
