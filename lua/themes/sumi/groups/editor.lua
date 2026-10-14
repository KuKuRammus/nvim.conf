-- Built-in UI: windows, gutter, statusline, popups, search, messages, diff, spelling.

return function(c)
  local bg = c.transparent and "NONE" or c.bg

  return {
    -- Base
    Normal       = { fg = c.fg, bg = bg },
    NormalNC     = { link = "Normal" },
    NormalFloat  = { fg = c.fg, bg = bg },
    FloatBorder  = { fg = c.border, bg = bg },
    FloatTitle   = { fg = c.fg_bright, bg = bg, bold = true },
    FloatFooter  = { fg = c.fg_muted, bg = bg },
    FloatShadow  = { bg = c.bg_dark, blend = 80 },
    FloatShadowThrough = { bg = c.bg_dark, blend = 100 },
    WinSeparator = { fg = c.border },
    VertSplit    = { link = "WinSeparator" },
    EndOfBuffer  = { fg = c.bg_alt },
    NonText      = { fg = c.guide },
    Whitespace   = { fg = c.guide },
    SpecialKey   = { fg = c.guide },
    Conceal      = { fg = c.comment },
    Directory    = { fg = c.accent_hi },
    Title        = { fg = c.fg_bright, bold = true },

    -- Cursor & lines
    Cursor       = { fg = c.on_accent, bg = c.fg },
    lCursor      = { link = "Cursor" },
    CursorIM     = { link = "Cursor" },
    TermCursor   = { link = "Cursor" },
    CursorLine   = { bg = c.bg_alt },
    CursorColumn = { bg = c.bg_alt },
    ColorColumn  = { bg = c.bg_alt },
    QuickFixLine = { bg = c.sel },

    -- Gutter
    LineNr       = { fg = c.dim },
    LineNrAbove  = { link = "LineNr" },
    LineNrBelow  = { link = "LineNr" },
    CursorLineNr = { fg = c.fg_bright, bold = true },
    SignColumn   = { fg = c.dim, bg = bg },
    CursorLineSign = { link = "SignColumn" },
    FoldColumn   = { fg = c.dim, bg = bg },
    CursorLineFold = { link = "FoldColumn" },
    Folded       = { fg = c.fg_muted, bg = c.bg_alt },

    -- Selection & search
    Visual       = { bg = c.sel },
    VisualNOS    = { link = "Visual" },
    Search       = { bg = c.search },
    CurSearch    = { fg = c.on_accent, bg = c.func, bold = true },
    IncSearch    = { link = "CurSearch" },
    Substitute   = { fg = c.on_accent, bg = c.member },
    MatchParen   = { fg = c.func, bg = c.bg_raised, bold = true },

    -- Statusline, winbar, tabline
    StatusLine       = { fg = c.fg, bg = c.bg_alt },
    StatusLineNC     = { fg = c.comment, bg = c.bg_dark },
    StatusLineTerm   = { link = "StatusLine" },
    StatusLineTermNC = { link = "StatusLineNC" },
    WinBar       = { fg = c.fg_muted, bg = bg, bold = true },
    WinBarNC     = { fg = c.comment, bg = bg },
    TabLine      = { fg = c.comment, bg = c.bg_dark },
    TabLineFill  = { bg = c.bg_dark },
    TabLineSel   = { fg = c.fg_bright, bg = c.bg, bold = true },

    -- Popup menu (built-in completion; blink.cmp links here unless overridden)
    Pmenu        = { fg = c.fg, bg = c.bg_alt },
    PmenuSel     = { bg = c.sel },
    PmenuKind    = { fg = c.type, bg = c.bg_alt },
    PmenuKindSel = { fg = c.type, bg = c.sel },
    PmenuExtra   = { fg = c.comment, bg = c.bg_alt },
    PmenuExtraSel = { fg = c.fg_muted, bg = c.sel },
    PmenuMatch   = { fg = c.accent_hi, bg = c.bg_alt, bold = true },
    PmenuMatchSel = { fg = c.accent_hi, bg = c.sel, bold = true },
    PmenuSbar    = { bg = c.bg_alt },
    PmenuThumb   = { bg = c.bg_raised },
    PmenuBorder  = { fg = c.border, bg = c.bg_alt },
    PmenuShadow  = { link = "FloatShadow" },
    PmenuShadowThrough = { link = "FloatShadowThrough" },
    WildMenu     = { link = "PmenuSel" },
    ComplMatchIns = { fg = c.dim },
    ComplHint    = { fg = c.dim },
    ComplHintMore = { fg = c.comment },
    PreInsert    = { fg = c.dim },
    SnippetTabstop = { bg = c.bg_raised },
    SnippetTabstopActive = { bg = c.sel },

    -- Messages
    MsgArea      = { fg = c.fg },
    MsgSeparator = { fg = c.border, bg = c.bg_dark },
    ModeMsg      = { fg = c.fg_muted, bold = true },
    MoreMsg      = { fg = c.accent_hi },
    Question     = { fg = c.accent_hi },
    ErrorMsg     = { fg = c.error },
    WarningMsg   = { fg = c.warn },
    OkMsg        = { fg = c.ok },
    StderrMsg    = { link = "ErrorMsg" },
    StdoutMsg    = { link = "MsgArea" },

    -- Diff (also used by gitsigns, fugitive, :diffthis)
    DiffAdd      = { bg = c.diff_add },
    DiffChange   = { bg = c.diff_change },
    DiffDelete   = { fg = c.removed, bg = c.diff_delete },
    DiffText     = { bg = c.diff_text },
    DiffTextAdd  = { bg = c.diff_text },
    Added        = { fg = c.added },
    Changed      = { fg = c.changed },
    Removed      = { fg = c.removed },

    -- Spelling
    SpellBad     = { sp = c.error, undercurl = true },
    SpellCap     = { sp = c.warn, undercurl = true },
    SpellLocal   = { sp = c.info, undercurl = true },
    SpellRare    = { sp = c.hint, undercurl = true },
  }
end
