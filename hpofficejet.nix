{pkgs, ...}:

{
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplip ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true; # Erlaubt Auflösung von .local Domains
    openFirewall = true; # Öffnet UDP 5353 für Avahi
  };

  # Firewall: Port 427 (SLP) wird oft für die HP-Erkennung benötigt
  #           Port 161 SNMP status check of HP Printers
  networking.firewall.allowedUDPPorts = [
    161
    427
  ];

}
