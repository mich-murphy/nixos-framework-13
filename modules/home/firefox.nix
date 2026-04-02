{pkgs, ...}: {
  programs.firefox = {
    enable = true;

    profiles.default = {
      isDefault = true;

      extensions.packages = with pkgs.firefox-addons; [
        ublock-origin
        onepassword-password-manager
        tokyo-night-v2
      ];

      search.default = "ddg";
      search.force = true;

      settings = {
        # Privacy & security
        "browser.contentblocking.category" = "strict";
        "dom.security.https_only_mode" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.query_stripping.enabled" = true;
        "privacy.query_stripping.enabled.pbmode" = true;
        "privacy.bounceTrackingProtection.mode" = 1;

        # DNS-over-HTTPS (Quad9, TRR-only)
        "network.trr.mode" = 3;
        "network.trr.uri" = "https://dns.quad9.net/dns-query";
        "network.trr.custom_uri" = "https://dns.quad9.net/dns-query";

        # Disable prefetch & speculative connections
        "network.prefetch-next" = false;
        "network.dns.disablePrefetch" = true;
        "network.http.speculative-parallel-limit" = 0;

        # Telemetry
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.usage.uploadEnabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;

        # UI
        "sidebar.verticalTabs" = true;
        "sidebar.revamp" = true;
        "sidebar.main.tools" = "history,bookmarks";
        "browser.fullscreen.autohide" = false;
        "browser.tabs.hoverPreview.enabled" = false;
        "browser.ml.linkPreview.enabled" = false;
        "browser.startup.page" = 3;

        # Autofill & passwords (using 1Password)
        "signon.rememberSignons" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;

        # Sponsored content
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;

        # Misc
        "media.eme.enabled" = true;
        "browser.aboutConfig.showWarning" = false;
        "browser.newtabpage.disableNewTabAsAddon" = true;
        "browser.aboutwelcome.enabled" = false;
        "extensions.pocket.enabled" = false;

        # CFR recommendations
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;

        # WebRTC leak prevention
        "media.peerconnection.ice.default_address_only" = true;
        "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;

        # Global Privacy Control
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.globalprivacycontrol.functionality.enabled" = true;

        # HTTPS-only hardening
        "dom.security.https_only_mode_send_http_background_request" = false;

        # Encrypted Client Hello
        "network.dns.echconfig.enabled" = true;
        "network.dns.use_https_rr_as_altsvc" = true;

        # Container tabs
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;
      };
    };
  };
}
