-- stevearc/oil.nvim
-- Pending actions use the version-control colors: create = added, delete = removed.

return function(c)
  return {
    OilDir        = { fg = c.accent_hi },
    OilDirIcon    = { fg = c.accent_hi },
    OilFile       = { fg = c.fg },
    OilLink       = { fg = c.tag },
    OilLinkTarget = { fg = c.comment },
    OilOrphanLink = { fg = c.error },
    OilOrphanLinkTarget = { fg = c.error },
    OilSocket     = { fg = c.constant },
    OilHidden     = { fg = c.comment },
    OilEmpty      = { fg = c.comment },

    OilCreate     = { fg = c.added },
    OilDelete     = { fg = c.removed },
    OilMove       = { fg = c.warn },
    OilCopy       = { fg = c.hint },
    OilChange     = { fg = c.changed },
    OilTrashSourcePath = { fg = c.comment },
  }
end
