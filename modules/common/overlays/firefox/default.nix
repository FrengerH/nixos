self: super:

with super;

let
in
  {
    firefox = wrapFirefox firefox-esr-unwrapped {
      nixExtensions = [
        (fetchFirefoxAddon {
          name = "bitwarden"; # Has to be unique!
          url = "https://addons.mozilla.org/firefox/downloads/file/3972752/bitwarden_password_manager-2022.6.1.xpi";
          sha256 = "3tij/Q6I3syxNUaFwM7Y1v01rx27Ez9TQekDudScxQ0=";
        })
        (fetchFirefoxAddon {
          name = "vimium-ff"; # Has to be unique!
          url = "https://addons.mozilla.org/firefox/downloads/file/2985278/vimium_ff-1.64.6.xpi";
          sha256 = "cES9OYPlQfry5WwRcEj9woHExS5BlkcvxPnkr0LF4do=";
        #  url = "https://addons.mozilla.org/firefox/downloads/file/3898202/vimium_ff-1.67.1.xpi";
        #  sha256 = "EnQIAnSOer/48TAUyEXbGCtSZvKA4vniL64K+CeJ/m0=";
        })
        (fetchFirefoxAddon {
          name = "noscript"; # Has to be unique!
          url = "https://addons.mozilla.org/firefox/downloads/file/3954910/noscript-11.4.6.xpi";
          sha256 = "X5F+VKUtcmmVmXbrtutB8aFMBHww1fe9akAf5BJvCzo=";
        })
        (fetchFirefoxAddon {
          name = "dark-reader"; # Has to be unique!
          url = "https://addons.mozilla.org/firefox/downloads/file/3968561/darkreader-4.9.52.xpi";
          sha256 = "QY3rCgqm7j4jwxur1XpcH8IHlFNW8GF+jdlVSW2AtG0=";
        })
      ];
      extraPolicies = {
        Bookmarks = [
          {
            "Title" = "Nixos packages";
            "URL" = "https://search.nixos.org/packages";
            "Favicon" = "https://nixos.org/favicon.png";
            "Placement" = "menu";
            "Folder" = "General";
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
        # Extensions = {
        #   Uninstall = [
        #     "amazon@search.mozilla.org"
        #     "amazondotcom@search.mozilla.org"
        #     "bing@search.mozilla.org"
        #     "ebay@search.mozilla.org"
        #     "google@search.mozilla.org"
        #     "wikipedia@search.mozilla.org"
        #   ];
        # };
        ExtensionSettings = {
          "amazon@search.mozilla.org" = {
            "installation_mode" = "blocked";
          };
          "amazondotcom@search.mozilla.org" = {
            "installation_mode" = "blocked";
          };
          "bing@search.mozilla.org" = {
            "installation_mode" = "blocked";
          };
          "ebay@search.mozilla.org" = {
            "installation_mode" = "blocked";
          };
          "google@search.mozilla.org" = {
            "installation_mode" = "blocked";
          };
          "wikipedia@search.mozilla.org" = {
            "installation_mode" = "blocked";
          };
        };
        # ExtensionSettings = ''
        #   {
        #     "amazon@search.mozilla.org": {
        #       "installation_mode": "blocked"
        #     },
        #     "amazondotcom@search.mozilla.org": {
        #       "installation_mode": "blocked"
        #     },
        #     "bing@search.mozilla.org": {
        #       "installation_mode": "blocked"
        #     },
        #     "ebay@search.mozilla.org": {
        #       "installation_mode": "blocked"
        #     },
        #     "google@search.mozilla.org": {
        #       "installation_mode": "blocked"
        #     },
        #     "wikipedia@search.mozilla.org": {
        #       "installation_mode": "blocked"
        #     }
        #   }
        # '';
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
        Preferences = ''
          {
            "browser.urlbar.suggest.bookmark": {
              "Value": true,
              "Status": "default"
            },
            "browser.urlbar.suggest.calculator": {
              "Value": false,
              "Status": "default"
            },
            "browser.urlbar.suggest.engines": {
              "Value": false,
              "Status": "default"
            },
            "browser.urlbar.suggest.history": {
              "Value": false,
              "Status": "default"
            },
            "browser.urlbar.suggest.openpage": {
              "Value": true,
              "Status": "default"
            },
            "browser.urlbar.suggest.quicksuggest": {
              "Value": false,
              "Status": "default"
            },
            "browser.urlbar.suggest.searches": {
              "Value": false,
              "Status": "default"
            },
            "browser.urlbar.suggest.topsites": {
              "Value": false,
              "Status": "default"
            },
            "browser.compactmode.show": {
              "Value": true,
              "Status": "default"
            },
            "browser.toolbars.bookmarks.visibility": {
              "Value": "never",
              "Status": "default"
            }
          }
        '';
      };
    };
  }

