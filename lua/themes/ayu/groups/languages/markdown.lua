-- Markdown (treesitter: markdown, markdown_inline).

return function(c)
  return {
    ["@markup.heading.markdown"]   = { fg = c.fg_bright, bold = true }, -- table header cells

    ["@markup.raw.block.markdown"]        = { fg = c.fg_muted },
    ["@label.markdown"]                   = { fg = c.comment },  -- code fence language
    ["@punctuation.special.markdown"]     = { fg = c.guide },    -- table pipes
    ["@markup.raw.markdown_inline"]       = { fg = c.regexp, bg = c.bg_alt },
    ["@markup.link.label.markdown_inline"] = { fg = c.accent_hi },
    ["@markup.link.url.markdown_inline"]  = { fg = c.comment, underline = true },
  }
end
