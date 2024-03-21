{ inputs, ... }:

final: prev: {
	newm = inputs.newm.packages.newm.overrideAttrs (old: rec {
		postInstall = ''
			mkdir -p $out/share/wayland-sessions/
			cp newm/resources/newm.desktop $out/share/wayland-sessions/
		'';
	
		passthru.providedSessions = [ "newm" ];
	});
}
