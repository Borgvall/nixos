{pkgs, ...}:

let 
  containerUser = "iris-development";
  containerUserHome = "/var/home/${containerUser}";
  containerName = containerUser;
  irisDataDir = "${containerUserHome}/iris-data";
  containerUid = 51773;  # DO NOT CHANGE THIS
  durableMountDir = "/dur";
  iscDataDirectory = "${durableMountDir}/iconfig";
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

  environment.shellAliases = let 
    run-in-container = command: "sudo -u ${containerUser} HOME=${containerUserHome} sh -c 'cd ${containerUserHome} && podman exec -it ${containerName} ${command}'";
  in {
    iris-bash = run-in-container "/bin/bash";
    iris-term = run-in-container "iris session IRIS";
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers."${containerName}" = {
      autoStart = false;
      podman = {
        user = containerUser;
      };
      hostname = containerName;
      image = "intersystems/iris-community:latest-em";
      ports = [
        "127.0.0.1:52773:52773"
        "127.0.0.1:1972:1972"
      ];
      extraOptions = [ "--userns=keep-id" ];
      volumes = [
        "${irisDataDir}:${durableMountDir}"
      ];
      environment = {
        ISC_DATA_DIRECTORY = iscDataDirectory;
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d ${irisDataDir} 0700 ${containerUser} ${containerUser} -"
  ];

  users.users."${containerUser}" = {
    isSystemUser = true;
    uid = containerUid;
    group = containerUser;
    createHome = true;
    home = containerUserHome;
    linger = true;
    extraGroups = [
      "podman"
    ];
    
    # Ermöglicht Rootless Podman das Mapping von UIDs innerhalb des Containers
    autoSubUidGidRange = true;
  };
  users.groups."${containerUser}" = {
    gid = containerUid;
  };
}
