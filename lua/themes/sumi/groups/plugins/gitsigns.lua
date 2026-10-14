-- lewis6991/gitsigns.nvim
-- Staged variants (GitSignsStaged*) are left undefined on purpose: gitsigns derives
-- them from these by dimming, which keeps staged/unstaged visually related.

return function(c)
  return {
    GitSignsAdd          = { fg = c.added },
    GitSignsChange       = { fg = c.changed },
    GitSignsDelete       = { fg = c.removed },
    GitSignsChangedelete = { fg = c.changed },
    GitSignsTopdelete    = { fg = c.removed },
    GitSignsUntracked    = { fg = c.dim },

    GitSignsAddNr        = { fg = c.added },
    GitSignsChangeNr     = { fg = c.changed },
    GitSignsDeleteNr     = { fg = c.removed },

    GitSignsAddLn        = { bg = c.diff_add },
    GitSignsChangeLn     = { bg = c.diff_change },

    GitSignsAddInline    = { bg = c.diff_add },
    GitSignsChangeInline = { bg = c.diff_text },
    GitSignsDeleteInline = { bg = c.diff_delete },
    GitSignsAddPreview    = { fg = c.added, bg = c.diff_add },
    GitSignsDeletePreview = { fg = c.removed, bg = c.diff_delete },
    GitSignsDeleteVirtLn  = { fg = c.removed, bg = c.diff_delete },
    GitSignsVirtLnum      = { fg = c.dim },

    GitSignsCurrentLineBlame = { fg = c.dim },
  }
end
