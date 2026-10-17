{pkgs, ...}:

{
  programs.mango.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    foot
    rofi
  ];
}
