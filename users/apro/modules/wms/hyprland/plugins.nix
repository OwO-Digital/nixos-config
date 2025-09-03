{ config, inputs, lib, pkgs, system, ... }: {

  wayland.windowManager.hyprland = {
    plugins = (with inputs.hyprland-plugins.packages.${system}; [
       hyprbars #crashes with hyprtrails but hyprbars suck anyways

      #hyprtrails #crashes with hyprbars
      # elly: prevents system update

      #hyprexpo
      # elly: prevents system update
    ]) ++ [
       inputs.hyprsplit.packages.${system}.hyprsplit
       # elly: prevents system update

      inputs.hypr-dynamic-cursors.packages.${system}.hypr-dynamic-cursors
      # elly: prevents system update
    ];

    settings = {
      plugin = {
        hyprsplit.num_workspaces = "6";

        dynamic-cursors = {
          enabled = "true";
          mode = "tilt";

          rotate = {
            length = "24";
            offset = "0.0";
          };

          shake.enabled = "true";
        };

        hyprbars = {
          bar_height = "24";
          bar_color = "rgb(141b1e)";
          "col.text" = "rgb(dadada)";
          bar_text_size = "12";
          bar_text_font = "Atkinson Hyperlegible Next";
          hyprbars-button = [
            "rgb(e57474), 12,, hyprctl dispatch killactive"
            "rgb(e5c76b), 12,, hyprctl dispatch swapwithmaster"
            "rgb(8ccf7e), 12,, hyprctl dispatch fullscreen 1"
          ];
        };

        hyprtrails.color = "rgba(67b0e880)";

        hyprexpo = {
          columns = "3";
          gap_size = "32";
          bg_col = "rgb(141b1e)";
          workspace_method = "first 1";
        };
      };
    };
  };
}
