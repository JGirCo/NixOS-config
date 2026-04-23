{
  config,
  theme,
  lib,
  ...
}:
let
  colors = import ../../colors.nix {
    inherit theme;
    inherit lib;
  };
  # from https://github.com/tridactyl/tridactyl/blob/master/.tridactylrc
  appconfig = ''

    " " Misc
    colors main

    " Movement
    bind j scrollpx 0 50
    bind k scrollpx 0 -50
    bind K scrollline -10
    bind J scrollline 10

    set smoothscroll true

    " " Comment toggler for Reddit, Hacker News and Lobste.rs
    bind ;c hint -Jc [class*="expand"],[class*="togg"],[class="comment_folder"]
    bind ;r hint -b -Jc [class*="bylink comments may-blank"],[class*="expando"]

    " " Hint fallback for modified websites
    bind ;f hint
    bind ;F hint -b

    " " Only hint results in DDG
    bindurl https://www.duckduckgo.com f hint -Jc [data-testid="result-title-a"]
    bindurl https://www.duckduckgo.com F hint -Jbc [data-testid="result-title-a"]

    " " Easier reddit navigation (with RES)
    bindurl https://old.reddit.com f hint -Jc [class*="comments"],[class*="expand"],[class*="res-step-next"]
    bindurl https://old.reddit.com F hint -Jbc [class*="comments"],[class*="title"],[class*="redditname"]

    " " Easier youtube navigation
    bindurl https://www.youtube.com f hint -Jc [class*="yt-simple-endpoint"],[class*="yt-spec-button-shape-next__button-text-content"]
    bindurl https://www.youtube.com F hint -Jbc [class*="yt-simple-endpoint"]

    " " Easier ytMusic navigation
    bindurl music.youtube.com f hint -c a, button, [role="button"], ytmusic-play-button-renderer, ytmusic-navigation-button-renderer

    " " Focus on input
    bind i focusinput

    " " b is bmarks T is tabs
    bind b fillcmdline bmarks
    bind T fillcmdline tab

    " " New reddit is bad
    autocmd DocStart ^http(s?)://www.reddit.com js tri.excmds.urlmodify("-t", "www", "old")

    " "
    set editorcmd kitty start nvim

    " " Search engines
    set searchurls.nix https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=
    set searchurls.no https://mynixos.com/search?q=
    set searchurls.red https://www.ecosia.org/search?&q=site%3Areddit.com+
    set searchurls.yt https://www.youtube.com/results?search_query=
    set searchurls.sub https://reddit.com/r/

    " " Easy access to dark reader settings
    unbind ;d
    bind ;dr open moz-extension://cc83bf43-cd13-4b64-9895-1ed9620a5620/ui/options/index.html

    " " Unbind annoying settings
    unbind gf
    bind gf hint -qb

    unbind d
    unbind u
  '';
  cssconfig =
    with config.colorScheme.palette;
    with colors;
    ''
      :root {
          --tridactyl-bg: #${base};
          --tridactyl-fg: #${text2};
          --tridactyl-status-border: 2px solid #${alt};
          --tridactyl-status-border-radius: 999px;
          --tridactyl-of-fg: #${text2};
          --tridactyl-of-bg: #${base};
          --tridactyl-hintspan-fg: #${text2};
          --tridactyl-hintspan-bg: #${base};
          --tridactyl-hintspan-border-color: #${focused};
          --tridactyl-hintspan-border-width: 1px;
          --tridactyl-hint-active-fg: #${base};
          --tridactyl-hint-active-bg: #${focused};
          --tridactyl-hint-active-outline: 0px solid #000;
          --tridactyl-hint-bg: color-mix(in srgb, #${focused}, transparent 90%);
          --tridactyl-hint-outline: 1px solid var(--tridactyl-hintspan-bg);
          --tridactyl-cmplt-option-height: 1.9em;
          --tridactyl-border-radius: 16px;
          --tridactyl-font-family: sans;
          --tridactyl-font-family-sans: sans;
          --tridactyl-font-size: 12pt;
          --tridactyl-small-font-size: 12px;
          --tridactyl-status-font-family: var(--tridactyl-font-family);
          --tridactyl-status-font-size: var(--tridactyl-small-font-size);
          --tridactyl-hintspan-font-family: var(--tridactyl-font-family-sans);
          --tridactyl-hintspan-font-size: var(--tridactyl-small-font-size);
          --tridactyl-hintspan-font-weight: bold;
          --tridactyl-vs-font-family: var(--tridactyl-font-family);
          --tridactyl-cmdl-font-family: var(--tridactyl-font-family);
          --tridactyl-cmdl-font-size: 15pt;
          --tridactyl-cmplt-font-size: 10pt;
          --tridactyl-cmplt-font-family: var(--tridactyl-font-family);
          --tridactyl-header-font-weight: bold;
      }

      :root.TridactylOwnNamespace {
          scrollbar-width: thin;
      }

      :root.TridactylOwnNamespace a {
          color: #3b84ef;
      }

      :root.TridactylOwnNamespace code {
          background-color: #2a333c;
          padding: 3px 7px;
      }

      :root #command-line-holder {
          border: 3px solid #${focused};
          border-radius: var(--tridactyl-border-radius) !important;
          order: 1;
      }

      :root #tridactyl-colon::before {
          content: "";
      }

      :root #tridactyl-input {
          width: 96%;
          padding: 1rem;
          border-radius: var(--tridactyl-border-radius) !important;
          padding-right: 4px !important;
      }

      :root #completions {
          border: 3px solid #${focused};
          order: 2;
          margin-top: 10px;
          border-radius: var(--tridactyl-border-radius);
          overflow: hidden;
      }



      :root #completions > div {
          max-height: calc(20 * var(--tridactyl-cmplt-option-height));
          min-height: calc(10 * var(--tridactyl-cmplt-option-height));
          padding: 1rem;
      }

      :root #completions > div > table {
        border-spacing: 5px;
        border-collapse: separate;
        table-layout: fixed;
        border-radius: var(--tridactyl-border-radius);
      }


      :root #completions table {
          padding: 1rem;
      }

      :root #completions table tr td {
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
          background-color: #${inactive};
          border-radius: 999px;
      }

      :root #completions table tr td.title,
      :root #completions table tr td.documentation,
      :root #completions table tr td.content {
          padding-left: 1rem;
      }

      :root #completions table tr .title {
          width: 50%;
      }

      :root #completions tr .documentation {
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
      }

      :root #completions .sectionHeader {
          background: #${alt};
          margin: 0 1rem 0 1rem !important;
          border-radius: var(--tridactyl-border-radius) !important;
          text-align: center !important;
      }


      #completions table tr td.prefix,
      #completions table tr td.container {
          display: none !important;
      }

      #completions table tr td.icon {
        background-color: transparent !important;
      }


      :root #body {
        width: calc(100% - 10px);
        background: transparent !important;
      }

      .focused td,
      .focused .url {
          background-color: #${focused} !important;
      }

      .url {
          background: #${inactive} !important;
          color: #${base} !important;
      }

      :root #cmdline_iframe {
          position: fixed !important;
          bottom: unset;
          top: 25% !important;
          left: 10% !important;
          z-index: 2147483647 !important;
          width: 80% !important;
          color-scheme: only light;
      }

      :root .TridactylStatusIndicator {
          position: fixed !important;
          bottom: 10px !important;
          right: 10px !important;
          font-weight: bold !important;
          padding: 5px !important;
      }

      span.TridactylHint {
          border-radius : 999px !important;
          min-width: 1em !important
      }

    '';
in
{
  xdg = {
    configFile = {
      tridactyl = {
        enable = true;
        target = "tridactyl/tridactylrc";
        text = appconfig;
      };
      tridactylcss = {
        enable = true;
        target = "tridactyl/themes/main.css";
        text = cssconfig;
      };
    };
  };
}
