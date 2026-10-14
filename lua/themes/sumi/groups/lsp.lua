-- Diagnostics (LSP, nvim-lint, ...), LSP UI and semantic tokens.
-- Semantic tokens link to treesitter captures so both sources look the same.

return function(c)
  local hl = {
    -- References, hints, lenses
    LspReferenceText   = { bg = c.bg_raised },
    LspReferenceRead   = { bg = c.bg_raised },
    LspReferenceWrite  = { bg = c.bg_raised, underline = true, sp = c.fg_muted },
    LspReferenceTarget = { link = "LspReferenceText" },
    LspInlayHint       = { fg = c.dim, bg = c.bg_alt },
    LspCodeLens        = { fg = c.dim },
    LspCodeLensSeparator = { fg = c.guide },
    LspSignatureActiveParameter = { fg = c.func, bold = true },

    -- Diagnostics: shared
    DiagnosticUnnecessary = { fg = c.comment },
    DiagnosticDeprecated  = { strikethrough = true, sp = c.comment },
  }

  local levels = {
    Error = { c.error, c.error_bg },
    Warn  = { c.warn, c.warn_bg },
    Info  = { c.info, c.info_bg },
    Hint  = { c.hint, c.hint_bg },
    Ok    = { c.ok, c.bg_alt },
  }
  for name, col in pairs(levels) do
    local fg, bg = col[1], col[2]
    hl["Diagnostic" .. name]                = { fg = fg }
    hl["DiagnosticSign" .. name]            = { fg = fg }
    hl["DiagnosticFloating" .. name]        = { fg = fg }
    hl["DiagnosticVirtualText" .. name]     = { fg = fg, bg = bg }
    hl["DiagnosticVirtualLines" .. name]    = { fg = fg }
    hl["DiagnosticUnderline" .. name]       = { sp = fg, undercurl = true }
  end

  -- Semantic tokens -> treesitter captures
  local tokens = {
    class         = "@type",
    comment       = false, -- keep treesitter comments (TODO/NOTE highlighting)
    decorator     = "@attribute",
    enum          = "@type",
    enumMember    = "@constant",
    event         = "@type",
    ["function"]  = "@function",
    interface     = "@type",
    keyword       = "@keyword",
    macro         = "@function.macro",
    method        = "@function.method",
    modifier      = "@keyword.modifier",
    namespace     = "@module",
    number        = "@number",
    operator      = "@operator",
    parameter     = "@variable.parameter",
    property      = "@property",
    regexp        = "@string.regexp",
    string        = "@string",
    struct        = "@type",
    type          = "@type",
    typeParameter = "@type.definition",
    variable      = "@variable",
  }
  for token, target in pairs(tokens) do
    hl["@lsp.type." .. token] = target and { link = target } or {}
  end

  hl["@lsp.mod.deprecated"]                     = { strikethrough = true }
  hl["@lsp.typemod.variable.defaultLibrary"]    = { link = "@variable.builtin" }
  hl["@lsp.typemod.function.defaultLibrary"]    = { link = "@function.builtin" }

  return hl
end
