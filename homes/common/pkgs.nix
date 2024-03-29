{ config, pkgs, ... }:
let
  yubikey-keygen = pkgs.writeShellApplication {
    name = "yubikey-keygen";
    runtimeInputs = [ pkgs.openssh ];
    text =
      let
        filename = "id_ed25519_sk_yubikey";
      in
      ''
        read -rp "Sure you want to Continue? (Y/N): " confirm && [[ $confirm == [yY] ]] || exit 1
        ${pkgs.openssh}/bin/ssh-keygen -t ed25519-sk -O resident -f ~/.ssh/${filename}
        echo "Adding key to keyring"
        ${pkgs.openssh}/bin/ssh-add -K
        echo "Key listing"
        ${pkgs.openssh}/bin/ssh-add -L
        rm ~/.ssh/${filename}
        echo "Final key listing"
        ${pkgs.openssh}/bin/ssh-add -L
      '';
  };
in
(with pkgs; [
  # Misc
  preconfigured
  custom-emacs
  tldr
  file

  # Yubikey 
  yubikey-manager
] ++ [
  yubikey-keygen
])
