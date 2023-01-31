''
/*==============================================================================================*

  +-----+-----+-----+-----+-----+-----+-----+
  | █▀▀ | ▄▀█ | █▀▀ | █▀▀ | ▄▀█ | █▀▄ | █▀▀ |
  | █▄▄ | █▀█ | ▄▄█ | █▄▄ | █▀█ | █▄▀ | ██▄ |
  +-----+-----+-----+-----+-----+-----+-----+

  Description:    Cascade is a minimalstic and keyboard centered custom theme removing a lot of the
                  subjective clutter default Firefox comes with. This theme is highly inspired by the
                  stylistic choices of SimpleFox by Miguel Ávila. 🦊
                  https://github.com/migueravila/SimpleFox

  Author:         Andreas Grafen
                  (https://andreas.grafen.info)

  Repository:     https://github.com/andreasgrafen/cascade
                  Thank you Nick, Abdallah, Benyamin and Wael for all the great suggestions for improvements! ♡

                  Nick:     https://github.com/nicksundermeyer
                  Abdallah: https://github.com/HeiWiper
                  Benyamin: https://github.com/benyaminl
                  Wael:     https://github.com/wael444

                  If you're looking for a **mouse-friendly** clone please check out Waterfall.
                  https://github.com/crambaud/waterfall

*==============================================================================================*/

:root {

	--uc-border-radius: 0px;  
	--uc-status-panel-spacing: 12px;
  
}
  
.titlebar-buttonbox-container { display: none !important; }
#pageActionButton { display: none !important; }
  
:root {
  
	--uc-toolbar-position: 0;
	--uc-darken-toolbar: .2;
  
}

:root {
  
	--uc-urlbar-min-width: 40vw;
	--uc-urlbar-max-width: 40vw; 
	--uc-urlbar-position: 1;
  
}

	#identity-permission-box { display: none !important; }
	#page-action-buttons > :not(#urlbar-zoom-button):not(#star-button-box) { display: none !important; }
	#urlbar-go-button { display: none !important; }
  
:root {
  
	--uc-active-tab-width:   clamp(100px, 30vw, 300px);
	--uc-inactive-tab-width: clamp(100px, 20vw, 200px);

  	--show-tab-close-button: none;
  	--show-tab-close-button-hover: -moz-inline-block;
  	--container-tabs-indicator-margin: 10px;
  	--uc-identity-glow: 0 1px 10px 1px;
  
}

.tab-secondary-label { display: none !important; }  

@media (prefers-color-scheme: dark) { :root {

  --uc-identity-colour-blue:      #89B4FA;
  --uc-identity-colour-turquoise: #94E2D5;
  --uc-identity-colour-green:     #A6E3A1;
  --uc-identity-colour-yellow:    #F9E2AF;
  --uc-identity-colour-orange:    #FAB387;
  --uc-identity-colour-red:       #F38BA8;
  --uc-identity-colour-pink:      #F5C2E7;
  --uc-identity-colour-purple:    #CBA6F7;

  --uc-base-colour:               #1E1E2E;
  --uc-highlight-colour:          #181825;
  --uc-inverted-colour:           #CDD6F4;
  --uc-muted-colour:              #6C7086;
  --uc-accent-colour:             var(--uc-identity-colour-purple);

}}


@media (prefers-color-scheme: light) { :root {

  --uc-identity-colour-blue:      #1E66F5;
  --uc-identity-colour-turquoise: #179299;
  --uc-identity-colour-green:     #40A02B;
  --uc-identity-colour-yellow:    #DF8E1D;
  --uc-identity-colour-orange:    #FE640B;
  --uc-identity-colour-red:       #D20F39;
  --uc-identity-colour-pink:      #D20F39;
  --uc-identity-colour-purple:    #8839EF;

  --uc-base-colour:               #EFF1F5;
  --uc-highlight-colour:          #DCE0E8;
  --uc-inverted-colour:           #4C4F69;
  --uc-muted-colour:              #9CA0B0;
  --uc-accent-colour:             var(--uc-identity-colour-purple);

}}

:root {

  --lwt-frame: var(--uc-base-colour) !important;
  --lwt-accent-color: var(--lwt-frame) !important;
  --lwt-text-color: var(--uc-inverted-colour) !important;

  --toolbar-field-color: var(--uc-inverted-colour) !important;

  --toolbar-field-focus-color: var(--uc-inverted-colour) !important;
  --toolbar-field-focus-background-color: var(--uc-highlight-colour) !important;
  --toolbar-field-focus-border-color: transparent !important;

  --toolbar-field-background-color: var(--lwt-frame) !important;
  --lwt-toolbar-field-highlight: var(--uc-inverted-colour) !important;
  --lwt-toolbar-field-highlight-text: var(--uc-highlight-colour) !important;
  --urlbar-popup-url-color: var(--uc-accent-colour) !important;

  --lwt-tab-text: var(--lwt-text-colour) !important;

  --lwt-selected-tab-background-color: var(--uc-highlight-colour) !important;

  --toolbar-bgcolor: var(--lwt-frame) !important;
  --toolbar-color: var(--lwt-text-color) !important;
  --toolbarseparator-color: var(--uc-accent-colour) !important;
  --toolbarbutton-hover-background: var(--uc-highlight-colour) !important;
  --toolbarbutton-active-background: var(--toolbarbutton-hover-background) !important;

  --lwt-sidebar-background-color: var(--lwt-frame) !important;
  --sidebar-background-color: var(--lwt-sidebar-background-color) !important;

  --urlbar-box-bgcolor: var(--uc-highlight-colour) !important;
  --urlbar-box-text-color: var(--uc-muted-colour) !important;
  --urlbar-box-hover-bgcolor: var(--uc-highlight-colour) !important;
  --urlbar-box-hover-text-color: var(--uc-inverted-colour) !important;
  --urlbar-box-focus-bgcolor: var(--uc-highlight-colour) !important;

}

.identity-color-blue      { --identity-tab-color: var(--uc-identity-colour-blue)      !important; --identity-icon-color: var(--uc-identity-colour-blue)      !important;  }
.identity-color-turquoise { --identity-tab-color: var(--uc-identity-colour-turquoise) !important; --identity-icon-color: var(--uc-identity-colour-turquoise) !important; }
.identity-color-green     { --identity-tab-color: var(--uc-identity-colour-green)     !important; --identity-icon-color: var(--uc-identity-colour-green)     !important; }
.identity-color-yellow    { --identity-tab-color: var(--uc-identity-colour-yellow)    !important; --identity-icon-color: var(--uc-identity-colour-yellow)    !important; }
.identity-color-orange    { --identity-tab-color: var(--uc-identity-colour-orange)    !important; --identity-icon-color: var(--uc-identity-colour-orange)    !important; }
.identity-color-red       { --identity-tab-color: var(--uc-identity-colour-red)       !important; --identity-icon-color: var(--uc-identity-colour-red)       !important; }
.identity-color-pink      { --identity-tab-color: var(--uc-identity-colour-pink)      !important; --identity-icon-color: var(--uc-identity-colour-pink)      !important; }
.identity-color-purple    { --identity-tab-color: var(--uc-identity-colour-purple)    !important; --identity-icon-color: var(--uc-identity-colour-purple)    !important; }


:root {

	--toolbarbutton-border-radius: var(--uc-border-radius) !important;
	--tab-border-radius: var(--uc-border-radius) !important;
	--arrowpanel-border-radius: var(--uc-border-radius) !important;
  
}
  
#main-window,
#toolbar-menubar,
#TabsToolbar,
#navigator-toolbox,
#sidebar-box,
#nav-bar { box-shadow: none !important; }
  
  
#main-window,
#toolbar-menubar,
#TabsToolbar,
#PersonalToolbar,
#navigator-toolbox,
#sidebar-box,
#nav-bar { border: none !important; }
  
.titlebar-spacer { display: none !important; }
  
#PersonalToolbar {
  
	padding: 6px !important;
	box-shadow: inset 0 0 50vh rgba(0, 0, 0, var(--uc-darken-toolbar)) !important;;
  
}
  
#statuspanel #statuspanel-label {
  
	border: none !important;
	border-radius: var(--uc-border-radius) !important;
  
}
  
@media (min-width: 1000px) {

	#navigator-toolbox { display: flex; flex-wrap: wrap; }
  
	#nav-bar {
		order: var(--uc-urlbar-position);
		width: var(--uc-urlbar-min-width);
	}
  
	#titlebar {
		order: 2;
		width: calc(100vw - var(--uc-urlbar-min-width) - 1px);
	}
  
	#PersonalToolbar {
		order: var(--uc-toolbar-position);
		width: 100%;
	}
  
	#navigator-toolbox:focus-within #nav-bar { width: var(--uc-urlbar-max-width); }
	#navigator-toolbox:focus-within #titlebar { width: calc(100vw - var(--uc-urlbar-max-width) - 1px); }
}
  
#statuspanel #statuspanel-label { margin: 0 0 var(--uc-status-panel-spacing) var(--uc-status-panel-spacing) !important; }

#nav-bar {
	padding-block-start: 0px !important;
  
	border:     none !important;
	box-shadow: none !important;
	background: transparent !important;
  }
  
  #urlbar,
  #urlbar * {
	padding-block-start: var(--uc-urlbar-top-spacing) !important;
  
	outline: none !important;
	box-shadow: none !important;
  }
  
  #urlbar-background { border: transparent !important; }
  
  #urlbar[focused='true']
	> #urlbar-background,
  #urlbar:not([open])
	> #urlbar-background { background: var(--toolbar-field-background-color) !important; }
  
  #urlbar[open]
	> #urlbar-background { background: var(--toolbar-field-background-color) !important; }
  
  .urlbarView-row:hover
	> .urlbarView-row-inner,
  .urlbarView-row[selected]
	> .urlbarView-row-inner { background: var(--toolbar-field-focus-background-color) !important; }

/* remove gap after pinned tabs */
#tabbrowser-tabs[haspinnedtabs]:not([positionpinnedtabs])
  > #tabbrowser-arrowscrollbox
  > .tabbrowser-tab[first-visible-unpinned-tab] { margin-inline-start: 0 !important; }

#alltabs-button { display: var(--uc-show-all-tabs-button) !important; }

.tabbrowser-tab
  >.tab-stack
  > .tab-background { box-shadow: none !important;  }

#tabbrowser-tabs:not([noshadowfortests]) .tabbrowser-tab:is([multiselected])
  > .tab-stack
  > .tab-background:-moz-lwtheme { outline-color: var(--toolbarseparator-color) !important; }

.tabbrowser-tab:not([pinned]) .tab-close-button { display: var(--show-tab-close-button) !important; }
.tabbrowser-tab:not([pinned]):hover .tab-close-button { display: var(--show-tab-close-button-hover) !important }

.tabbrowser-tab[selected][fadein]:not([pinned]) { max-width: var(--uc-active-tab-width) !important; }
.tabbrowser-tab[fadein]:not([selected]):not([pinned]) { max-width: var(--uc-inactive-tab-width) !important; }

.tabbrowser-tab[usercontextid]
  > .tab-stack
  > .tab-background
  > .tab-context-line {

    margin: -1px var(--container-tabs-indicator-margin) 0 var(--container-tabs-indicator-margin) !important;
    height: 1px !important;

    box-shadow: var(--uc-identity-glow) var(--identity-tab-color) !important;
}

.tab-icon-image:not([pinned]) { opacity: 1 !important; }

.tab-icon-overlay:not([crashed]),
.tab-icon-overlay[pinned][crashed][selected] {

  top: 5px !important;
  z-index: 1 !important;

  padding: 1.5px !important;
  inset-inline-end: -8px !important;
  width: 16px !important; height: 16px !important;

  border-radius: 10px !important;
}

.tab-icon-overlay:not([sharing], [crashed]):is([soundplaying], [muted], [activemedia-blocked]) {

  stroke: transparent !important;
  background: transparent !important;
  opacity: 1 !important; fill-opacity: 0.8 !important;

  color: currentColor !important;

  stroke: var(--toolbar-bgcolor) !important;
  background-color: var(--toolbar-bgcolor) !important;
}

.tabbrowser-tab[selected] .tab-icon-overlay:not([sharing], [crashed]):is([soundplaying], [muted], [activemedia-blocked]) {

  stroke: var(--toolbar-bgcolor) !important;
  background-color: var(--toolbar-bgcolor) !important;
}

.tab-icon-overlay:not([pinned], [sharing], [crashed]):is([soundplaying], [muted], [activemedia-blocked]) { margin-inline-end: 9.5px !important; }

.tabbrowser-tab:not([image]) .tab-icon-overlay:not([pinned], [sharing], [crashed]) {

  top: 0 !important;

  padding: 0 !important;
  margin-inline-end: 5.5px !important;
  inset-inline-end: 0 !important;
}

.tab-icon-overlay:not([crashed])[soundplaying]:hover,
.tab-icon-overlay:not([crashed])[muted]:hover,
.tab-icon-overlay:not([crashed])[activemedia-blocked]:hover {

  color: currentColor !important;
  stroke: var(--toolbar-color) !important;
  background-color: var(--toolbar-color) !important;
  fill-opacity: 0.95 !important;
}

.tabbrowser-tab[selected] .tab-icon-overlay:not([crashed])[soundplaying]:hover,
.tabbrowser-tab[selected] .tab-icon-overlay:not([crashed])[muted]:hover,
.tabbrowser-tab[selected] .tab-icon-overlay:not([crashed])[activemedia-blocked]:hover {

  color: currentColor !important;
  stroke: var(--toolbar-color) !important;
  background-color: var(--toolbar-color) !important;
  fill-opacity: 0.95 !important;
}

#TabsToolbar .tab-icon-overlay:not([crashed])[soundplaying],
#TabsToolbar .tab-icon-overlay:not([crashed])[muted],
#TabsToolbar .tab-icon-overlay:not([crashed])[activemedia-blocked] { color: var(--toolbar-color) !important; }

#TabsToolbar .tab-icon-overlay:not([crashed])[soundplaying]:hover,
#TabsToolbar .tab-icon-overlay:not([crashed])[muted]:hover,
#TabsToolbar .tab-icon-overlay:not([crashed])[activemedia-blocked]:hover { color: var(--toolbar-bgcolor) !important; }


#TabsToolbar { display: none !important; }
#nav-bar { width: 100vw !important; }



#browser { position: relative; }
#sidebar-box[sidebarcommand*="tabcenter"] #sidebar-header { display: none; }

#sidebar-box[sidebarcommand*="tabcenter"]:not([hidden]) {

  display: block;

  position: absolute;
  top: 0; bottom: 0;
  z-index: 1;

  min-width: 50px !important; max-width: 50px !important;

  border-right: none;

  transition: all 0.2s ease;

  overflow: hidden;

}

[sidebarcommand*="tabcenter"] #sidebar,
#sidebar-box[sidebarcommand*="tabcenter"]:hover { min-width: 10vw !important; width: 30vw !important; max-width: 250px !important; }

[sidebarcommand*="tabcenter"] #sidebar { height: 100%; max-height: 100%; }

#sidebar-box[sidebarcommand*="tabcenter"]:not([hidden]) ~ #appcontent { margin-left: 50px; }
#main-window[inFullscreen][inDOMFullscreen] #appcontent { margin-left: 0; }
/* Removes gap between active tab highlight and edge of bar */
#sidebar-box[sidebarcommand="tabcenter-reborn_ariasuni-sidebar-action"] #sidebar-header, #sidebar-box[sidebarcommand="tabcenter-reborn_ariasuni-sidebar-action"] ~ #sidebar-splitter {
    display: none;
}
''