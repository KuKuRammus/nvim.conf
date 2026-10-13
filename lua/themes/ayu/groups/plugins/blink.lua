-- saghen/blink.cmp

return function(c)
  local hl = {
    BlinkCmpMenu          = { fg = c.fg, bg = c.bg_alt },
    BlinkCmpMenuBorder    = { fg = c.border, bg = c.bg_alt },
    BlinkCmpMenuSelection = { bg = c.sel },
    BlinkCmpScrollBarThumb  = { bg = c.bg_raised },
    BlinkCmpScrollBarGutter = { bg = c.bg_alt },

    BlinkCmpLabel            = { fg = c.fg },
    BlinkCmpLabelMatch       = { fg = c.accent_hi, bold = true },
    BlinkCmpLabelDeprecated  = { fg = c.comment, strikethrough = true },
    BlinkCmpLabelDetail      = { fg = c.comment },
    BlinkCmpLabelDescription = { fg = c.comment },
    BlinkCmpSource           = { fg = c.dim },
    BlinkCmpGhostText        = { fg = c.dim },

    BlinkCmpDoc          = { fg = c.fg, bg = c.bg_alt },
    BlinkCmpDocBorder    = { fg = c.border, bg = c.bg_alt },
    BlinkCmpDocSeparator = { fg = c.border, bg = c.bg_alt },
    BlinkCmpDocCursorLine = { bg = c.sel },

    BlinkCmpSignatureHelp       = { fg = c.fg, bg = c.bg_alt },
    BlinkCmpSignatureHelpBorder = { fg = c.border, bg = c.bg_alt },
    BlinkCmpSignatureHelpActiveParameter = { fg = c.func, bold = true },

    BlinkCmpKind = { fg = c.fg_muted },
  }

  -- Completion item kind icons, colored like the syntax they represent
  local kinds = {
    Text = c.fg_muted,   Method = c.func,      Function = c.func,     Constructor = c.type,
    Field = c.member,    Variable = c.fg,      Class = c.type,        Interface = c.type,
    Module = c.tag,      Property = c.member,  Unit = c.constant,     Value = c.constant,
    Enum = c.type,       Keyword = c.keyword,  Snippet = c.regexp,    Color = c.special,
    File = c.fg,         Reference = c.special, Folder = c.accent_hi, EnumMember = c.constant,
    Constant = c.constant, Struct = c.type,    Event = c.type,        Operator = c.operator,
    TypeParameter = c.type,
  }
  for kind, fg in pairs(kinds) do
    hl["BlinkCmpKind" .. kind] = { fg = fg }
  end

  return hl
end
