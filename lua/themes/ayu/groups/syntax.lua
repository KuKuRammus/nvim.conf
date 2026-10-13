-- Legacy Vim syntax groups (:h group-name). Used by regex syntax files, and as the
-- fallback for any treesitter/LSP capture the theme doesn't define.

return function(c)
  return {
    Comment        = { fg = c.comment, italic = true },
    SpecialComment = { fg = c.comment, italic = true, bold = true },
    Todo           = { fg = c.func, bold = true },

    Constant       = { fg = c.constant },
    String         = { fg = c.string },
    Character      = { fg = c.string },
    Number         = { fg = c.constant },
    Float          = { fg = c.constant },
    Boolean        = { fg = c.constant },

    Identifier     = { fg = c.fg },
    Function       = { fg = c.func },

    Statement      = { fg = c.keyword },
    Conditional    = { fg = c.keyword },
    Repeat         = { fg = c.keyword },
    Label          = { fg = c.keyword },
    Keyword        = { fg = c.keyword },
    Exception      = { fg = c.keyword },
    Operator       = { fg = c.operator },

    PreProc        = { fg = c.keyword },
    Include        = { fg = c.keyword },
    Define         = { fg = c.keyword },
    PreCondit      = { fg = c.keyword },
    Macro          = { fg = c.func },

    Type           = { fg = c.type },
    StorageClass   = { fg = c.keyword },
    Structure      = { fg = c.type },
    Typedef        = { fg = c.type },

    Special        = { fg = c.special },
    SpecialChar    = { fg = c.regexp },
    Tag            = { fg = c.tag },
    Delimiter      = { fg = c.fg_muted },
    Debug          = { fg = c.warn },

    Underlined     = { fg = c.accent_hi, underline = true },
    Ignore         = { fg = c.comment },
    Error          = { fg = c.error },
  }
end
