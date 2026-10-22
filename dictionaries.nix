{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    hyphen
    hyphenDicts.de_DE
    hyphenDicts.en_US
  ];

  # Damit Apps die Wörterbücher auch finden:
  environment.sessionVariables = {
    DICPATH = "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen";
  };
}
