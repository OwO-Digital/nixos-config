{ pkgs, ... }: {
  programs.btop = {
    enable = true;
    package = pkgs.btop.override {
      rocmSupport = true;
    };

    # All graphs and meters can be gradients
    # For single color graphs leave "mid" and "end" variable empty.
    # Use "start" and "end" variables for two color gradient
    # Use "start", "mid" and "end" for three color gradient
    themes.sonokaiShusia = ''
      # Main background, empty for terminal default, need to be empty if you want transparent background
      #theme[main_bg]="#060604"

      # Main text color
      theme[main_fg]="#E3E1E4"

      # Title color for boxes
      theme[title]="#E3E1E4"

      # Highlight color for keyboard shortcuts
      theme[hi_fg]="#F85E84"

      # Background color of selected item in processes box
      theme[selected_bg]="#55393D"

      # Foreground color of selected item in processes box
      theme[selected_fg]="#E4E1E4"

      # Color of inactive/disabled text
      theme[inactive_fg]="#605D68"

      # Color of text appearing on top of graphs, i.e uptime and current network graph scaling
      theme[graph_text]="#848089"

      # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
      theme[proc_misc]="#605D68"

      # Cpu box outline color
      theme[cpu_box]="#9ECD6F"

      # Memory/disks box outline color
      theme[mem_box]="#E5C463"

      # Net up/down box outline color
      theme[net_box]="#AB9DF2"

      # Processes box outline color
      theme[proc_box]="#F85E84"

      # Box divider line and small boxes line color
      theme[div_line]="#605D68"

      # Temperature graph colors
      theme[temp_start]="#7ACCD7"
      theme[temp_mid]="#AB9DF2"
      theme[temp_end]="#F85E84"

      # CPU graph colors
      theme[cpu_start]="#9ECD6F"
      theme[cpu_mid]="#E5C463"
      theme[cpu_end]="#F85E84"

      # Mem/Disk free meter
      theme[free_start]="#9ECD6F"
      #theme[free_mid]="#E5C463"
      #theme[free_end]="#F85E84"

      # Mem/Disk cached meter
      theme[cached_start]="#7ACCD7"
      #theme[cached_mid]="#66D9EF"
      #theme[cached_end]="#aae7f2"

      # Mem/Disk available meter
      theme[available_start]="#EF9062"
      #theme[available_mid]="#E6DB74"
      #theme[available_end]="#f2ecb6"

      # Mem/Disk used meter
      theme[used_start]="#F85E84"
      #theme[used_mid]="#F92672"
      #theme[used_end]="#ff87b2"

      # Download graph colors
      theme[download_start]="#7ACCD7"
      #theme[download_mid]="#7352a8"
      #theme[download_end]="#ccaefc"

      # Upload graph colors
      theme[upload_start]="#AB9DF2"
      #theme[upload_mid]="#cf277d"
      #theme[upload_end]="#fa91c7"
    '';
  };
}
