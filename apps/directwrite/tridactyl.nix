{ config, theme, lib, ... }:
let
  colors = import ../../colors.nix {
    inherit theme;
    inherit lib;
  };
  # from https://github.com/tridactyl/tridactyl/blob/master/.tridactylrc
  appconfig = ''
    " " Binds
    " "
    "
    " Movement
    bind j scrollpx 0 50
    bind k scrollpx 0 -50
    bind K scrollline -10
    bind J scrollline 10

    unbind u

    set smoothscroll true

    colors main

    " " Comment toggler for Reddit, Hacker News and Lobste.rs
    bind ;c hint -Jc [class*="expand"],[class*="togg"],[class="comment_folder"]
    bind ;r hint -b -Jc [class="bylink comments may-blank"]

    " " Only hint results in DDG
    bindurl https://duckduckgo.com f hint -Jc [data-testid="result-title-a"]
    bindurl https://duckduckgo.com F hint -Jbc [data-testid="result-title-a"]

    " " Focus on input
    bind i focusinput


    " " make d take you to the left (I find it much less confusing)
    bind d composite tabprev; tabclose #
    bind D tabclose

    " " Binds for new reader mode
    " bind gr reader
    " bind gR reader --tab
    "
    " " New reddit is bad
    autocmd DocStart ^http(s?)://www.reddit.com js tri.excmds.urlmodify("-t", "www", "old")
  '';
  cssconfig = with config.colorScheme.palette;
    with colors; ''
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
          --tridactyl-hintspan-border-width: 3px;
          --tridactyl-hint-active-fg: #${base};
          --tridactyl-hint-active-bg: #${focused};
          --tridactyl-hint-active-outline: 0px solid #000;
          --tridactyl-hint-bg: color-mix(in srgb, #${focused}, transparent 95%)
          --tridactyl-hint-outline: 1px solid var(--tridactyl-hintspan-bg);
          --tridactyl-cmplt-option-height: 1.9em;
          --tridactyl-border-radius: 16px;
          --tridactyl-font-family: serif;
          --tridactyl-font-family-sans: serif;
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


      body {
          width: calc(100% - 10px);
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
in {
  home.file.".config/tridactyl/tridactylrc".text = appconfig;
  home.file.".config/tridactyl/themes/main.css".text = cssconfig;
}
