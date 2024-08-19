p = {
    black:       "#1a181a"
    bg_dim:      "#211f21"
    bg0:         "#2d2a2e"
    bg1:         "#37343a"
    bg2:         "#3b383e"
    bg3:         "#423f46"
    bg4:         "#49464e"
    gray_dim:    "#605d68"
    red:         "#f85e84"
    orange:      "#ef9062"
    yellow:      "#e5c463"
    green:       "#9ecd6f"
    blue:        "#7accd7"
    purple:      "#ab9df2"
    fg:          "#e3e1e4"
    gray:        "#848089"
    bg_red:      "#ff6188"
    diff_red:    "#55393d"
    diff_green:  "#394634"
    bg_green:    "#a9dc76"
    bg_blue:     "#78dce8"
    diff_blue:   "#354157"
    diff_yellow: "#4e432f"
}

scheme = with {}
    .foreground = p.fg
    .background = "#343136"
    --            ^ default terminal
    --            | background on the VSCode
    --            | version

    .cursor_bg = p.fg
    .cursor_fg = "#477379"
    --           ^ used in fg text
    --           | on blue here: 
    --           | https://github.com/sainnhe/sonokai
    .cursor_border = .cursor_bg

    .selection_bg = p.red  -- just personal preference
    .selection_fg = "#993E55"
    --           ^ used in fg text
    --           | on red here: 
    --           | https://github.com/sainnhe/sonokai

    .scrollbar_thumb = p.bg4

    .split = p.black

    .ansi = {
        .background
        p.red
        p.green
        p.yellow
        p.blue
        p.purple
        "#78dce8"  -- FIXME: too similar to blue
        .foreground
    }

    .brights = .ansi
    .brights[1] = p.bg4

    .tab_bar = {}
    .tab_bar.background = p.bg0
    --.tab_bar.background = "#242124"

    .tab_bar.active_tab = {
        bg_color: .background
        fg_color: .foreground
    }
    .tab_bar.inactive_tab = {
        bg_color: .tab_bar.background
        fg_color: p.gray
        intensity: "Half"
    }
    .tab_bar.inactive_tab_hover = {
        bg_color: .tab_bar.background
        fg_color: p.red
        italic: false
        intensity: "Bold"
    }

    .tab_bar.new_tab       = .tab_bar.inactive_tab
    .tab_bar.new_tab_hover = .tab_bar.inactive_tab_hover

return scheme