return {
    s({trig="ltex", snippetType="snippet", desc="LTeX: set language", wordTrig=true},
        {t("// LTeX: language="), i(1, "es")}
    ),
    s({trig="ltoff", snippetType="snippet", desc="LTeX: disable checking", wordTrig=true},
        {t("// LTeX: enabled=false")}
    ),
    s({trig="lton", snippetType="snippet", desc="LTeX: enable checking", wordTrig=true},
        {t("// LTeX: enabled=true")}
    ),
    s({trig="ltdict", snippetType="snippet", desc="LTeX: add word to dictionary", wordTrig=true},
        {t("// LTeX: dictionary+="), i(1, "word")}
    ),
    s({trig="ltrule", snippetType="snippet", desc="LTeX: disable a rule", wordTrig=true},
        {t("// LTeX: rules-="), i(1, "RULE_ID")}
    ),
}
