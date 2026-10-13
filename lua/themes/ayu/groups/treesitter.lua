-- Base treesitter captures (:h treesitter-highlight-groups), shared by every language.
-- Language-specific overrides (@capture.<lang>) live in groups/languages/.

return function(c)
  return {
    -- Variables
    ["@variable"]                   = { fg = c.fg },
    ["@variable.builtin"]           = { fg = c.tag },     -- self, this
    ["@variable.parameter"]         = { fg = c.special },
    ["@variable.parameter.builtin"] = { fg = c.special },
    ["@variable.member"]            = { fg = c.member },
    ["@property"]                   = { fg = c.member },

    -- Constants
    ["@constant"]         = { fg = c.constant },
    ["@constant.builtin"] = { fg = c.constant },
    ["@constant.macro"]   = { fg = c.constant },
    ["@boolean"]          = { fg = c.constant },
    ["@number"]           = { fg = c.constant },
    ["@number.float"]     = { fg = c.constant },

    -- Modules, labels
    ["@module"]         = { fg = c.tag },
    ["@module.builtin"] = { fg = c.tag },
    ["@label"]          = { fg = c.keyword },

    -- Strings
    ["@string"]                = { fg = c.string },
    ["@string.documentation"]  = { fg = c.string },
    ["@string.regexp"]         = { fg = c.regexp },
    ["@string.escape"]         = { fg = c.regexp },
    ["@string.special"]        = { fg = c.special },
    ["@string.special.symbol"] = { fg = c.constant },
    ["@string.special.path"]   = { fg = c.string },
    ["@string.special.url"]    = { fg = c.accent_hi, underline = true },
    ["@character"]             = { fg = c.string },
    ["@character.special"]     = { fg = c.regexp },

    -- Types
    ["@type"]            = { fg = c.type },
    ["@type.builtin"]    = { fg = c.type },
    ["@type.definition"] = { fg = c.type },
    ["@attribute"]       = { fg = c.special },
    ["@attribute.builtin"] = { fg = c.special },
    ["@constructor"]     = { fg = c.type },

    -- Functions
    ["@function"]             = { fg = c.func },
    ["@function.builtin"]     = { fg = c.func },
    ["@function.call"]        = { fg = c.func },
    ["@function.macro"]       = { fg = c.func },
    ["@function.method"]      = { fg = c.func },
    ["@function.method.call"] = { fg = c.func },

    -- Keywords & operators
    ["@keyword"]                     = { fg = c.keyword },
    ["@keyword.coroutine"]           = { fg = c.keyword },
    ["@keyword.function"]            = { fg = c.keyword },
    ["@keyword.operator"]            = { fg = c.keyword },
    ["@keyword.import"]              = { fg = c.keyword },
    ["@keyword.type"]                = { fg = c.keyword },
    ["@keyword.modifier"]            = { fg = c.keyword },
    ["@keyword.repeat"]              = { fg = c.keyword },
    ["@keyword.return"]              = { fg = c.keyword },
    ["@keyword.debug"]               = { fg = c.keyword },
    ["@keyword.exception"]           = { fg = c.keyword },
    ["@keyword.conditional"]         = { fg = c.keyword },
    ["@keyword.conditional.ternary"] = { fg = c.operator },
    ["@keyword.directive"]           = { fg = c.keyword },
    ["@keyword.directive.define"]    = { fg = c.keyword },
    ["@operator"]                    = { fg = c.operator },

    -- Punctuation
    ["@punctuation.delimiter"] = { fg = c.fg_muted },
    ["@punctuation.bracket"]   = { fg = c.fg_muted },
    ["@punctuation.special"]   = { fg = c.special },

    -- Comments
    ["@comment"]               = { link = "Comment" },
    ["@comment.documentation"] = { link = "Comment" },
    ["@comment.error"]         = { fg = c.error, bold = true },
    ["@comment.warning"]       = { fg = c.warn, bold = true },
    ["@comment.todo"]          = { fg = c.func, bold = true },
    ["@comment.note"]          = { fg = c.info, bold = true },

    -- Markup (markdown, vimdoc, rst, ...)
    ["@markup.strong"]         = { bold = true },
    ["@markup.italic"]         = { italic = true },
    ["@markup.strikethrough"]  = { strikethrough = true },
    ["@markup.underline"]      = { underline = true },
    ["@markup.heading"]        = { fg = c.member, bold = true },
    ["@markup.heading.1"]      = { fg = c.keyword, bold = true },
    ["@markup.heading.2"]      = { fg = c.func, bold = true },
    ["@markup.heading.3"]      = { fg = c.string, bold = true },
    ["@markup.heading.4"]      = { fg = c.type, bold = true },
    ["@markup.heading.5"]      = { fg = c.constant, bold = true },
    ["@markup.heading.6"]      = { fg = c.regexp, bold = true },
    ["@markup.quote"]          = { fg = c.fg_muted, italic = true },
    ["@markup.math"]           = { fg = c.regexp },
    ["@markup.link"]           = { fg = c.accent_hi },
    ["@markup.link.label"]     = { fg = c.special },
    ["@markup.link.url"]       = { fg = c.accent_hi, underline = true },
    ["@markup.raw"]            = { fg = c.regexp },
    ["@markup.raw.block"]      = { fg = c.fg },
    ["@markup.list"]           = { fg = c.keyword },
    ["@markup.list.checked"]   = { fg = c.ok },
    ["@markup.list.unchecked"] = { fg = c.comment },

    -- Diff
    ["@diff.plus"]  = { fg = c.added },
    ["@diff.minus"] = { fg = c.removed },
    ["@diff.delta"] = { fg = c.changed },

    -- Tags (HTML, XML, JSX)
    ["@tag"]           = { fg = c.tag },
    ["@tag.builtin"]   = { fg = c.tag },
    ["@tag.attribute"] = { fg = c.special },
    ["@tag.delimiter"] = { fg = c.fg_muted },
  }
end
