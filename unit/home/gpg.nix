{flake, ...}: {
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        text = flake.inputs.self.consts.gpg;
        trust = 5;
      }
    ];
  };
}
