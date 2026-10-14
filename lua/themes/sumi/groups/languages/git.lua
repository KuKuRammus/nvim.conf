-- Git commit messages, rebase todo lists, diffs/patches.
-- Treesitter captures plus the legacy syntax groups (used by fugitive and when no parser is installed).

return function(c)
  return {
    -- gitcommit
    ["@markup.heading.gitcommit"]  = { fg = c.fg_bright, bold = true }, -- summary line
    ["@comment.error.gitcommit"]   = { fg = c.error },                  -- summary overflow
    ["@keyword.gitcommit"]         = { fg = c.keyword },
    ["@string.special.path.gitcommit"] = { fg = c.fg },
    gitcommitSummary  = { fg = c.fg_bright, bold = true },
    gitcommitOverflow = { fg = c.error },
    gitcommitBranch   = { fg = c.accent_hi },
    gitcommitHeader   = { fg = c.comment },
    gitcommitSelectedType = { fg = c.added },
    gitcommitDiscardedType = { fg = c.removed },
    gitcommitUntrackedFile = { fg = c.comment },

    -- git_rebase
    ["@keyword.git_rebase"]  = { fg = c.keyword },
    ["@constant.git_rebase"] = { fg = c.comment }, -- commit hashes

    -- diff / patch
    ["@attribute.diff"] = { fg = c.tag },          -- @@ hunk headers
    ["@string.special.path.diff"] = { fg = c.fg_bright },
    diffAdded    = { fg = c.added },
    diffRemoved  = { fg = c.removed },
    diffChanged  = { fg = c.changed },
    diffFile     = { fg = c.fg_bright, bold = true },
    diffOldFile  = { fg = c.removed },
    diffNewFile  = { fg = c.added },
    diffIndexLine = { fg = c.comment },
    diffLine     = { fg = c.tag },
    diffSubname  = { fg = c.fg_muted },
  }
end
