{consts, ...}: {
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        text = consts.gpg;
        trust = 5;
      }
    ];
  };
}
