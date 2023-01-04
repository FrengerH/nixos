{ config, pkgs }:

let 
  startupScript = pkgs.writeShellScriptBin "startupScript" (builtins.readFile ../../scripts/tmux-start.sh); 
  muteMic = pkgs.writeShellScriptBin "muteMic" (builtins.readFile ../../scripts/toggle_input.sh); 
  muteAudio = pkgs.writeShellScriptBin "muteAdio" (builtins.readFile ../../scripts/toggle_output.sh); 
  notesFile = "${config.notesDir}/notes.txt";
in {
  config = ''
    
    /* See LICENSE file for copyright and license details. */

    /* appearance */
    static const unsigned int borderpx  = 1;        /* border pixel of windows */
    static const unsigned int snap      = 32;       /* snap pixel */
    static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
    static const unsigned int systrayspacing = 2;   /* systray spacing */
    static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
    static const int showsystray        = 1;     /* 0 means no systray */
    static const int showbar            = 1;     /* 0 means no bar */
    static const int topbar             = 1;     /* 0 means bottom bar */
    static const int focusonwheel       = 0;
    static const char *fonts[]          = { "FiraCode Nerd Font:size=10", "monospace:size=10" };
    static const char dmenufont[]       = "monospace:size=10";
    static const char col_gray1[]       = "#222222";
    static const char col_gray2[]       = "#444444";
    static const char col_gray3[]       = "#bbbbbb";
    static const char col_gray4[]       = "#eeeeee";
    static const char col_cyan[]        = "#005577";
    static const char col1[]            = "#ffffff";
    static const char col2[]            = "#ffffff";
    static const char col3[]            = "#ffffff";
    static const char col4[]            = "#ffffff";
    static const char col5[]            = "#ffffff";
    static const char col6[]            = "#ffffff";

    enum { SchemeNorm, SchemeCol1, SchemeCol2, SchemeCol3, SchemeCol4,
           SchemeCol5, SchemeCol6, SchemeSel }; /* color schemes */

    static const char *colors[][3]      = {
        /*               fg         bg         border   */
        [SchemeNorm]  = { col_gray3, col_gray1, col_gray2 },
        [SchemeCol1]  = { col1,      col_gray1, col_gray2 },
        [SchemeCol2]  = { col2,      col_gray1, col_gray2 },
        [SchemeCol3]  = { col3,      col_gray1, col_gray2 },
        [SchemeCol4]  = { col4,      col_gray1, col_gray2 },
        [SchemeCol5]  = { col5,      col_gray1, col_gray2 },
        [SchemeCol6]  = { col6,      col_gray1, col_gray2 },
        [SchemeSel]   = { col_gray4, col_cyan,  col_cyan  },
    };

    typedef struct {
        const char *name;
        const void *cmd;
    } Sp;
    const char *spcmd1[] = {"st", "-T", "st-scratchpad", NULL };
    const char *spcmd2[] = {"st", "-T", "Spotify-tui", "-e", "spt", NULL };
    const char *spcmd3[] = {"st", "-T", "Calculator", "-e", "rink", NULL };
    const char *spcmd4[] = {"st", "-T", "Notes", "-e", "nvim", "${notesFile}", NULL };
    const char *spcmd5[] = {"pavucontrol", NULL};
    /*
    const char *spcmd2[] = {"st", "-n", "spfm", "-g", "144x41", "-e", "ranger", NULL };
    const char *spcmd3[] = {"keepassxc", NULL };
    */
    static Sp scratchpads[] = {
        /* name                       cmd  */
        {"st-scratchpad",             spcmd1},
        {"Spotify-tui",               spcmd2},
        {"Calculator",                spcmd3},
        {"Notes",                     spcmd4},
        {"Pavucontrol",               spcmd5},
        /*{"keepassxc",                 spcmd3},*/
    };

    /* tagging */
    static const char *tags[] = {  " ₁", " ₂", " ₃", " ₄", " ₅", " ₆", " ₇", " ₈", " ₉" };

    static const Rule rules[] = {
        /* xprop(1):
         *	WM_CLASS(STRING) = instance, class
         *	WM_NAME(STRING) = title
         */
        /* class                       instance               title                     tags mask     isfloating   monitor */
            { "firefox",                   NULL,              NULL,                     1,            0,           -1 },
            { NULL,                        NULL,              "st-scratchpad",          SPTAG(0),     1,           -1 },
            { NULL,                        NULL,              "Spotify-tui",            SPTAG(1),     1,           -1 },
            { NULL,                        NULL,              "Calculator",             SPTAG(2),     1,           -1 },
            { NULL,                        NULL,              "Notes",                  SPTAG(3),     1,           -1 },
            { "jetbrains-phpstorm",        NULL,              NULL,                     1 << 1,       0,           -1 },
            { "Org.gnome.Nautilus",        NULL,              NULL,                     1 << 2,       0,           -1 },
            { "DBeaver",                   NULL,              NULL,                     1 << 3,       0,           -1 },
            { "Mysql-workbench-bin",       NULL,              NULL,                     1 << 3,       0,           -1 },
            { "robo3t",                    NULL,              NULL,                     1 << 3,       0,           -1 },
            { "Gimp",                      NULL,              NULL,                     1 << 4,       0,           -1 },
            { "VirtualBox Manager",        NULL,              NULL,                     1 << 5,       0,           -1 },
            { "Virt-manager",              NULL,              NULL,                     1 << 5,       0,           -1 },
            { "org.remmina.Remmina",       NULL,              NULL,                     1 << 5,       0,           -1 },
            { "Microsoft Teams - Preview", NULL,              NULL,                     1 << 6,       0,           -1 },
            { "Code",                      NULL,              NULL,                     1 << 7,       0,           -1 },
            { "Sublime_text",              NULL,              NULL,                     1 << 8,       0,           -1 },
            { NULL,                        NULL,              "Volume Control",         SPTAG(4),     1,           -1 },
    };

    /* layout(s) */
    static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
    static const int nmaster     = 1;    /* number of clients in master area */
    static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
    static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

    static const Layout layouts[] = {
        /* symbol     arrange function */
        { "[]=",      tile },    /* first entry is default */
        { "[M]",      monocle },
        /*{ "><>",      NULL },*/    /* no layout function means floating behavior */
    };

    /* key definitions */
    #define MODKEY Mod4Mask
    #define TAGKEYS(KEY,TAG) \
        { MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
        { MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
        { MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
        { MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

    /* helper for spawning shell commands in the pre dwm-5.0 fashion */
    #define SHCMD(cmd) { .v = (const char*[]){ "/usr/bin/fish", "-c", cmd, NULL } }

    /* commands */
    static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
    static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };

    static const char *roficmd[]          = { "launcher", NULL };
    static const char *powermenucmd[]     = { "power-menu", NULL };
    static const char *termcmd[]          = { "st", "-T", "st", "-e", "${startupScript}/bin/startupScript", NULL };
    static const char *browsercmd[]       = { "firefox-esr", NULL };
    static const char *filescmd[]         = { "nemo", NULL };
    static const char *flameshotcmd[]     = { "flameshot", "gui", NULL };
    /* static const char *pavuctrlcmd[]   = { "pavucontrol", NULL }; */
    static const char *lockcmd[]          = { "light-locker-command", "-l", NULL };

    static const char *upvol[]   = { "pactl", "set-sink-volume", "0", "+3%",     NULL };
    static const char *downvol[] = { "pactl", "set-sink-volume", "0", "-3%",     NULL };
    static const char *mutevol[] = { "${muteAudio}/bin/muteAudio",  NULL };
    static const char *mutemic[] = { "${muteMic}/bin/muteMic",  NULL };

    static const char *upbrightness[]   = { "brightnessctl", "--device=intel_backlight", "set", "+2%", NULL };
    static const char *downbrightness[] = { "brightnessctl", "--device=intel_backlight", "set", "2%-", NULL };

    #include "movestack.c"
    #include <X11/XF86keysym.h>

    static Key keys[] = {
        /* modifier              key                            function        argument */
        { 0,                     XF86XK_MonBrightnessUp,        spawn,          {.v = upbrightness } },
        { 0,                     XF86XK_MonBrightnessDown,      spawn,          {.v = downbrightness } },
        { 0,                     XF86XK_AudioMicMute,           spawn,          {.v = mutemic } },
        { 0,                     XF86XK_AudioRaiseVolume,       spawn,          {.v = upvol } },
        { 0,                     XF86XK_AudioLowerVolume,       spawn,          {.v = downvol } },
        { 0,                     XF86XK_AudioMute,              spawn,          {.v = mutevol } },

        { 0,                     XF86XK_Launch8,                spawn,          {.v = flameshotcmd } },
        { 0,                     XK_Print,                      spawn,          {.v = flameshotcmd } },

        { MODKEY,                XK_0,                          view,           {.ui = ~0 } },
        { MODKEY,     	         XK_a,  	                    togglescratch,  {.ui = 0 } },
        { MODKEY,     	         XK_c,  	                    togglescratch,  {.ui = 2 } },
        { MODKEY,     	         XK_d,  	                    togglescratch,  {.ui = 1 } },
        { MODKEY,     	         XK_z,  	                    togglescratch,  {.ui = 3 } },
        { MODKEY,     	         XK_v,  	                    togglescratch,  {.ui = 4 } },
        { MODKEY,                XK_b,                          spawn,          {.v = browsercmd } },
        { MODKEY,                XK_f,                          spawn,          {.v = filescmd } },
        { MODKEY,                XK_i,                          setmfact,       {.f = +0.05} },
        { MODKEY,                XK_n,                          focusstack,      {.i = +1 } },
        { MODKEY,                XK_e,                          focusstack,      {.i = -1 } },
        { MODKEY,                XK_l,                          spawn,          {.v = lockcmd } },
        { MODKEY,                XK_m,                          setmfact,       {.f = -0.05} },
        { MODKEY,                XK_r,                          spawn,          {.v = roficmd } },
        { MODKEY,                XK_q,                          spawn,          {.v = powermenucmd } },
        /* { MODKEY,                XK_v,                          spawn,          {.v = pavuctrlcmd } }, */
        { MODKEY,                XK_x,                          killclient,     {0} },
        { MODKEY,                XK_Tab,                        focusstack,     {.i = +1 } },
        { MODKEY,                XK_Return,                     spawn,          {.v = termcmd } },
        { MODKEY,                XK_space,                      layoutscroll,   {.i = +1} },
        { MODKEY,                XK_comma,                      focusmon,       {.i = -1 } },
        { MODKEY,                XK_period,                     focusmon,       {.i = +1 } },

        { MODKEY|ShiftMask,      XK_0,                          tag,            {.ui = ~0 } },
        /*{ MODKEY|ShiftMask,      XK_b,                          togglebar,      {0} },*/
        /*{ MODKEY|ShiftMask,      XK_f,                          setlayout,      {.v = &layouts[1]} },*/
        { MODKEY|ShiftMask,      XK_n,                          movestack,     {.i = +1 } },
        { MODKEY|ShiftMask,      XK_e,                          movestack,     {.i = -1 } },
        /*{ MODKEY|ShiftMask,      XK_m,                          setlayout,      {.v = &layouts[2]} },*/
        /*{ MODKEY|ShiftMask,      XK_t,                          setlayout,      {.v = &layouts[0]} },*/
        /*{ MODKEY|ShiftMask,      XK_q,                          quit,           {0} },*/
        { MODKEY|ShiftMask,      XK_space,                      togglefloating, {0} },
        { MODKEY|ShiftMask,      XK_comma,                      tagmon,         {.i = -1 } },
        { MODKEY|ShiftMask,      XK_period,                     tagmon,         {.i = +1 } },
          /*{ MODKEY|ShiftMask,      XK_h,                          layoutscroll,   {.i = -1 } },
            { MODKEY|ShiftMask,      XK_l,                          layoutscroll,   {.i = +1 } },*/

        /* { MODKEY|ControlMask,    XK_r,                          self_restart,   {0} }, */
        { MODKEY|ControlMask,    XK_Return,                     zoom,           {0} },
        { MODKEY|ControlMask,    XK_Tab,                        view,           {0} },
          /*{ MODKEY|ControlMask,    XK_i,                          incnmaster,     {.i = +1 } },
        { MODKEY|ControlMask,    XK_d,                          incnmaster,     {.i = -1 } },*/
        
        //Tags
        /* TAGKEYS(                 XK_q,                                           0) */
        /* TAGKEYS(                 XK_w,                                           1) */ 
        /* TAGKEYS(                 XK_f,                                           2) */
        /* TAGKEYS(                 XK_p,                                           3) */
        /* TAGKEYS(                 XK_b,                                           4) */
        /* TAGKEYS(                 XK_j,                                           5) */
        /* TAGKEYS(                 XK_l,                                           6) */
        /* TAGKEYS(                 XK_u,                                           7) */
        /* TAGKEYS(                 XK_y,                                           8) */
        TAGKEYS(                 XK_1,                                           0)
        TAGKEYS(                 XK_2,                                           1)
        TAGKEYS(                 XK_3,                                           2)
        TAGKEYS(                 XK_4,                                           3)
        TAGKEYS(                 XK_5,                                           4)
        TAGKEYS(                 XK_6,                                           5)
        TAGKEYS(                 XK_7,                                           6)
        TAGKEYS(                 XK_8,                                           7)
        TAGKEYS(                 XK_9,                                           8)
    };

    /* button definitions */
    /* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
    static Button buttons[] = {
        /* click                event mask      button          function        argument */
        { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
        { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
        { ClkWinTitle,          0,              Button2,        zoom,           {0} },
        { ClkStatusText,        0,              Button1,        sigdwmblocks,   {.i = 1} },
        { ClkStatusText,        0,              Button2,        sigdwmblocks,   {.i = 2} },
        { ClkStatusText,        0,              Button3,        sigdwmblocks,   {.i = 3} },
        { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
        { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
        { ClkClientWin,         MODKEY,         Button1,        resizemouse,    {0} },
        { ClkTagBar,            0,              Button1,        view,           {0} },
        { ClkTagBar,            0,              Button3,        toggleview,     {0} },
        { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
        { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
    };

    static const char *ipcsockpath = "/tmp/dwm.sock";
    static IPCCommand ipccommands[] = {
      IPCCOMMAND(  view,                1,      {ARG_TYPE_UINT}   ),
      IPCCOMMAND(  toggleview,          1,      {ARG_TYPE_UINT}   ),
      IPCCOMMAND(  tag,                 1,      {ARG_TYPE_UINT}   ),
      IPCCOMMAND(  toggletag,           1,      {ARG_TYPE_UINT}   ),
      IPCCOMMAND(  tagmon,              1,      {ARG_TYPE_UINT}   ),
      IPCCOMMAND(  focusmon,            1,      {ARG_TYPE_SINT}   ),
      IPCCOMMAND(  focusstack,          1,      {ARG_TYPE_SINT}   ),
      IPCCOMMAND(  zoom,                1,      {ARG_TYPE_NONE}   ),
      IPCCOMMAND(  incnmaster,          1,      {ARG_TYPE_SINT}   ),
      IPCCOMMAND(  killclient,          1,      {ARG_TYPE_SINT}   ),
      IPCCOMMAND(  togglefloating,      1,      {ARG_TYPE_NONE}   ),
      IPCCOMMAND(  setmfact,            1,      {ARG_TYPE_FLOAT}  ),
      IPCCOMMAND(  setlayoutsafe,       1,      {ARG_TYPE_PTR}    ),
      IPCCOMMAND(  quit,                1,      {ARG_TYPE_NONE}   )
    };

  '';
}
