{ pkgs }:

{
  enable = true;
  package = pkgs.firefox-esr;
  preferences = {
    "browser.requireSigning" = false;
    "browser.urlbar.suggest.bookmark" = true;
    "browser.urlbar.suggest.calculator" = false;
    "browser.urlbar.suggest.engines" = false;
    "browser.urlbar.suggest.history" = false;
    "browser.urlbar.suggest.openpage" = true;
    "browser.urlbar.suggest.quicksuggest" = false;
    "browser.urlbar.suggest.searches" = false;
    "browser.urlbar.suggest.topsites" = false;
    "browser.compactmode.show" = true;
    "browser.toolbars.bookmarks.visibility" = "never";
  };
  policies = {
    Bookmarks = [
      {
        "Title" = "Nixos packages";
        "URL" = "https://search.nixos.org/packages?channel=23.11&from=0&size=50&sort=relevance&type=packages&query=%s";
        "Favicon" = "https://nixos.org/favicon.png";
        "Placement" = "menu";
        "Folder" = "General";
        "Keyword" = "nix";
      }
      {
        "Title" = "Nixos gh";
        "URL" = "https://github.com/NixOS/nixpkgs";
        "Placement" = "menu";
        "Folder" = "General";
      }
    ];
    CaptivePortal = false;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    DisableFirefoxAccounts = true;
    DisableFormHistory = true;
    FirefoxHome = {
      Search = false;
      TopSites = false;
      SponsoredTopSites = false;
      Highlights = false;
      Pocket = false;
      SponsoredPocket = false;
      Snippets = false;
      Locked = false;
    };
    Homepage = {
      StartPage = "none";
    };
    OfferToSaveLogins = false;
    SearchSuggestEnabled = false;
    NoDefaultBookmarks = true;
    SanitizeOnShutdown = {
      Cache = false;
      Cookies = false;
      Downloads = true;
      FormData = true;
      History = true;
      Sessions = false;
      SiteSettings = false;
      OfflineApps = false;
      Locked = false;
    };
    UserMessaging = {
      ExtensionRecommendations = false;
      SkipOnboarding = true;
    };
    ExtensionSettings = {
      "*".installation_mode = "blocked";
      # Search "guid": on addons install page ff
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/file/4219948/bitwarden_password_manager-2024.1.0.xpi";
        installation_mode = "force_installed";
      };
      "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/file/4191523/vimium_ff-2.0.6.xpi";
        installation_mode = "force_installed";
      };
      "{73a6fe31-595d-460b-a920-fcc0f8843232}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/file/4206186/noscript-11.4.29.xpi";
        installation_mode = "force_installed";
      };
      "addon@darkreader.org" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/file/4223104/darkreader-4.9.76.xpi";
        installation_mode = "force_installed";
      };
      "{806cbba4-1bd3-4916-9ddc-e719e9ca0cbf}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/file/4141260/xdebug_helper_for_firefox-1.0.10.xpi";
        installation_mode = "force_installed";
      };
    };
    SearchEngines = {
      Default = "DuckDuckGo";
      Remove = [
        "Google"
        "Amazon.nl"
        "Amazon.co.uk"
        "Bing"
        "eBay"
        "Wikipedia (en)"
      ];
    };
  };
}

