{
  ...
}:
let
  keys = [
    "hp/Y8zjEakZZBUC2AYn/bPJbKAZ0yXiG5INXKnBpTPSC8NYzverEIIzzoN87W9axTw9iRKZPbtVKTr/nf1RxXQ==,RQm/VMMK7rpFxEl1uIEVQtOCLjNBbDFW5hAVH2TUDns3C5pKuZwkCaKd7X7RBA2J0ajrbgKQ/9HHHJFJssnSwg==,es256,+presence"
    "XK0cl3usvxxtQjxdC28Cu82vWtIMbAjPQSdvykX4+qHlVHtA3o3kBgaeQcCUktnpRzymItUOLPsWrFvxNTyUfQ==,yZ95I8NlnprZeE3uJKno5YZ/ysfr/YZlPcnNlxJv/1AWVE0GS2/C+VK2Oa160kfbhRGQZeOzgUAt0WL/A02yyg==,es256,+presence"
  ];
  authfile = builtins.toFile "u2f_keys" "pop:${builtins.concatStringsSep ":" keys}";
in
{
  security.pam.u2f = {
    enable = true;
    settings = {
      inherit authfile;
      cue = true;
    };
  };

  services.pcscd.enable = true;
}
