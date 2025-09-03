{ config, lib, pkgs, ... }: {

	wayland.windowManager.hyprland.settings =
	let
		mod = "SUPER";

		term = "foot";
		run = "rofi -show drun";
	in {

		gesture = [
			"3, vertical, workspace"
		];
		bind = [
			"${mod}, Return, exec, ${term}"
			"${mod}, Q, killactive"
			"${mod}_SHIFT, BackSpace, exit"
			"${mod}_SHIFT, space, togglefloating"
			"${mod}, R, exec, ${run}"
			# "${mod}, slash, hyprexpo:expo, toggle"

			"${mod}, J, cyclenext"
			"${mod}, K, cyclenext, prev"
			"${mod}_SHIFT, J, swapnext"
			"${mod}_SHIFT, K, swapnext, prev"

			"${mod}, mouse_down, workspace, e+1"
			"${mod}, mouse_up, workspace, e-1"
		] ++ (
			builtins.concatLists (builtins.genList (i:
				let ws = i + 1;
				in [
					"${mod}, code:1${toString i}, split:workspace, ${toString ws}"
					"${mod}_SHIFT, code:1${toString i}, split:movetoworkspacesilent, ${toString ws}"
				]
			)
			6 )
		);

		bindm = [
			"${mod}, mouse:272, movewindow"
			"${mod}, mouse:273, resizewindow"
		];
	};
}
