{flake, ...}: {
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        text = flake.self.consts.gpg;
        trust = 5;
      }
    ];
  };
}
