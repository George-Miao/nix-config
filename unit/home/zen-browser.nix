{...}: let
  extension_latest = name: "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
in {
  programs.zen-browser = {
    enable = true;

    policies = {
      AppAutoUpdate = false;
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      Extensions = {
        Install = [
          "https://www.zotero.org/download/connector/dl?browser=firefox"
          (extension_latest "ublock-origin")
          (extension_latest "privacy-badger17")
          (extension_latest "clearurls")
          (extension_latest "decentraleyes")
          (extension_latest "bitwarden-password-manager")
          (extension_latest "styl-us")
          (extension_latest "return-youtube-dislikes")
          (extension_latest "csgofloat")
          (extension_latest "ecosia-the-green-search")
          (extension_latest "react-devtools")
        ];
      };
    };
  };
}
