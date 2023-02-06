{
	config,
	pkgs,
	...
}: {
	programs.firefox = {
		enable = true;

		profiles = {
			apro = {
				id = 0;
				extensions = with pkgs.nur.repos.rycee.firefox-addons; [
					ublock-origin
					darkreader
					sponsorblock
					return-youtube-dislikes
					tabcenter-reborn
					stylus
					enhanced-github
					refined-github
					octotree
					new-tab-override
					h264ify
					i-dont-care-about-cookies
				];
				settings = {
					"browser.startup.homepage" = "https://start.emii.lol/";
					"general.smoothScrolling" = true;
				
					# Enable DRM support (Spotify, Netflix, so on and so forth... i really don't want to enable this, but... oh well...)
				  "media.eme.enabled" = true;
				  "media.gmp-widevinecdm.enabled" = true;
				  "media.gmp-widevinecdm.visible" = true;
				
				  # Remove annoying indicator that's shown when webcam or mic is in use via firefox.
				  "privacy.webrtc.legacyGlobalIndicator" = false;
				  "privacy.webrtc.hideGlobalIndicator" = true;
				};
				
				userChrome = import ./userChrome.nix;
				# userContent = import ./userContent.nix;
				
				extraConfig = ''
				  user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
				  user_pref("full-screen-api.ignore-widgets", false);
				  user_pref("media.ffmpeg.vaapi.enabled", true);
				  user_pref("media.rdd-vpx.enabled", true);
				'';
			};
		};
	};
}
