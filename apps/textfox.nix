{ lib, theme, font, ... }:
let

  colors = import ../colors.nix {
    inherit theme;
    inherit lib;
  };

in {
  textfox = {
    enable = true;
    profile = "f2lrn5k1";
    config = {

      # background.color = "color-mix(in srgb, #${colors.base}, transparent 25%)";
      border = {
        color = "#${colors.alt}";
        width = "1px";
        transition = "1.0s ease";
        radius = "10px";
      };
      font = {
        family = "${font.name}";
        size = "20px";
        accent = "#${colors.focused}";
      };
      tabs.horizontal.enable = true;
      newtabLogo =
        "\nA\nA\nA\n                            )`·.            )\\                                                                                 '                                                  ’                            )`·.            )                                                                                          A\n       )`·.             .·´   ..:).·´(_ .·´   `·.’'                                              '                                   (`·.                    )`·._.·´(        )`·.       )`·.             .·´   ..:).·´(_ .·´   `·.’'                               )`·.                          .·´(                    A\n        \\::’·._)'·.  (::::....   .. .:(      .:::)            (`·.              )             (`·.               )'                 ::`·._)`·.     ).·´::...  .::)   .·´   ./        ::’·._)'·.  (::::....   .. .:(      .:::)                   /(      .·´    (             /(.·´(      )::..:`·.( `·.           A\n  .·´(   )::. ..:::).·´;·::  ´ ´\\::.    ::....:·´               )  `·.   .·´( .·´  (             )  `·.   .·´( .·´  (     /('     .·´(   )::. ..:::).·´;· --  ´ ´::.`·.(::...:(’    .·´(   )::. ..:::).·´;·::  ´ ´::.    ::....:·´            )      )  `·._):::.    )        '’   )::..::`·._/;;  --  ' '.::)  )    ’'A\n  ):..\\(;;::--  ´ ´               :::::::..::)         .·´( .·´:..::(,(::--  ' ':·´     .·´( .·´:..::(,(::--  ' '::.`·._) `·.’  ):..(;;::--  ´ ´               ’:::::::...::)    ):..(;;::--  ´ ´               :::::::..::)        ) .·´ .:`·.(:;;  --  ' ':. :(.·´)    ) .·´;; --  ' '               /.·´ .:(.·´(A\n (::...:/\\                          ¯¯¯¯¯¯ /·.'      :::....::::·´         _’'     );; :--   '               ::....:::::)(::...:/                          ’¯¯¯¯¯¯/'    (::...:/                          ¯¯¯¯¯¯ /·.'.·´  (,): --  ' '              ....:::`·.(  ():/                 ,..::´/):::..::::·´A\n   `·:/::::\\...:’/        ___________/..::)        )..:::·´      ,..:´:::'/'   .·´/                ,...__ ¯¯¯` ·:·´’  `·:/::::...:´/        ___________'/        `·:/::::...:’/        ___________/..::)):.::/                        ¯¯¯` · ::·´’I/::::...:´/       ::::'/ /¯¯¯¯’/  A\n      \\::::/::::/        /::::::::::::·-  ´ ´/            `·::/       /::::::::/     )/:::'...:´/       /:::::::::::/     /        ::::/::::/        /:::::::::;; --  ´ ´     ’      ::::/::::/        /::::::::::::·-  ´ ´/    `·:/::::...:´/       ____                ::::/:::'/:::       -´ '/       /    A\n        \\/;::-'/        /;;::·-  ’ ´         _               /       /;;::· ´         :::/::::/       /;;::;;´-··´´     /  '         /;::-'/        /;;::·-  ´ ´         _    '        /;::-'/        /;;::·-  ’ ´         _       ::::/::::/      /::::::::/I        /    ’'   /;::-' ::::'       /       /      A\n             /                      .,.,·:::::/              /       /                  '\\/;::-'/               ,...::::´/     '             /                      .,.,·:::::'/   ’'             /                      .,.,·:::::/         /;::-'/      /::::::::/:/       /'                  :::::            /        A\n   )`·.   '’/         _ .,., ·:::::::::::::::/       (`·.)':/       /             '           /       ,, -,      \\::::::/    '     )`·.    '/         _ ,.,.,·:::::::::::::::/     '   )`·.   '’/         _ .,., ·:::::::::::::::/               /      /¯¯¯¯¯'I/       /''                     :::/                    A\n (::..:(.·/         /::::::::::::::::--  ´ ´           ):./       /                   .·´( '/       /:::/::\\      :· ´         (::..:(.·/         /:::::::::::::::::::--  ´      ’ (::..:(.·/         /::::::::::::::::--  ´ ´               '/      /          /       /         '             )'/       /      '      A\n  `·:...'/         /:::::::: · ´                   '   '\\:/       /                  '_) ::/       '/;;:/::::'      '          ’' `·::..'/          `·__:::::· ’:   .·´             `·:...'/         /:::::::: · ´                   '       /I      'I         /       /'      '        )    .·´.:/       /:::           A\n     ):/         /··  ´                                /       /                    )..::/       /    '\\::::::'      '              )/`·.                        (              ’     ):/         /··  ´                                 /::/`· ,    ` ·,_'/       /’            .·´.::.`·.):.'/.. - ··  ´´       .·´/'   A\n     '/         /                                  '  '/,..::·´/                     '`·:/____ /       '\\::::::____           /::::::`·._____ ...·::::::/                     '/         /                                  '    I:/::::::::` · , ___,.·:/'             '`·::..;::-  '        ..-:::::'/::::/'    'A\n   '/,...:::· ´/                    '                '/:::::::/                      ' /::::::::/           '\\::::/:::::::/           `·:::::::/::::::::/:::::::::/                 ’   '/,...:::· ´/                    '                    `·:;::::::::::/:::::/:::/'      '           )/::`*..¸..-::::::::::::/:::·´’      A\n  /::::::::::/                                     /:;:: · ´                        /::::::::/              '\\/:::::::'/     '           `·::/::::::::/::::: ·´´                   ’  /::::::::::/                                               ` ·:;:::/:::::/;·´'             '     /::::::::/::::::::::-·· ´´            A\n'/;:: ·   ´                  '                      ¯                              ’'¯¯¯¯¯                 ¯¯¯¯          ’            ¯¯¯¯¯                              '/;:: ·   ´                  '                                       ¯¯¯ ’                       `*-::;/::::-·· ´´'’                   'A\nA\n      ";
    };
  };
}
