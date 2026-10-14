-- Every color the theme uses. Group files only reference these names (c.<name>);
-- referencing a name that isn't defined here is an error at compile time.

local c = {
  -- Options ----------------------------------------------------------------
  transparent = false, -- true: editor background is NONE (terminal shows through)

  -- Surfaces, darkest to lightest -------------------------------------------
  bg_dark   = "#0c0e11", -- statusline (inactive), tabline fill, deepest layer
  bg        = "#111316", -- editor, floats, sidebars
  bg_alt    = "#16181d", -- cursorline, statusline, completion menu
  bg_raised = "#22242a", -- hovered / raised elements, scrollbar thumb
  border    = "#2a2d34", -- float and window borders, separators
  guide     = "#34373e", -- whitespace, indent guides, fold markers

  -- Text ---------------------------------------------------------------------
  fg_bright = "#f1f1f1", -- emphasis: titles, cursor line number
  fg        = "#bebdb9", -- default text
  fg_muted  = "#959699", -- secondary text: details, inactive labels
  comment   = "#5f636e", -- comments, disabled text
  dim       = "#4f545d", -- line numbers, ghost text

  -- Accent -------------------------------------------------------------------
  accent    = "#0a84c6", -- focus, current item marker, active tab
  accent_hi = "#59c2ff", -- links, accent text on dark backgrounds
  on_accent = "#0c0e11", -- text drawn on top of accent backgrounds
  sel       = "#1b374d", -- visual selection, selected list item (accent, heavily darkened)

  -- Syntax (Ayu Dark) --------------------------------------------------------
  keyword   = "#ff8f40", -- keywords, storage, control flow
  func      = "#ffb454", -- functions, methods
  string    = "#aad94c", -- strings
  regexp    = "#95e6cb", -- regexes, escapes
  constant  = "#d2a6ff", -- numbers, booleans, constants
  type      = "#59c2ff", -- types, classes
  tag       = "#39bae6", -- tags, builtins, modules
  special   = "#e6c08a", -- special characters, decorators, attributes
  operator  = "#f29668", -- operators
  member    = "#f07178", -- fields, properties, markup headings

  -- State --------------------------------------------------------------------
  error     = "#f07178",
  warn      = "#ffb454",
  info      = "#59c2ff",
  hint      = "#95e6cb",
  ok        = "#aad94c",

  -- Version control ----------------------------------------------------------
  added     = "#70bf56",
  changed   = "#73b8ff",
  removed   = "#f26d78",

  -- Tinted backgrounds (state color mixed ~12-35% into bg) -------------------
  diff_add    = "#1f2b21",
  diff_change = "#1f2935",
  diff_delete = "#302124",
  diff_text   = "#2c3f53", -- changed part inside a changed line
  search      = "#263332", -- search matches (teal tint)
  error_bg    = "#241c1f",
  warn_bg     = "#24211e",
  info_bg     = "#192229",
  hint_bg     = "#1d2425",

  -- Terminal (:terminal), same as the Alacritty palette ----------------------
  term = {
    "#0c0e11", "#f07178", "#aad94c", "#ffb454", "#59c2ff", "#d2a6ff", "#39bae6", "#bebdb9",
    "#5f636e", "#f07178", "#aad94c", "#ffb454", "#59c2ff", "#d2a6ff", "#39bae6", "#f1f1f1",
  },
}

return setmetatable(c, {
  __index = function(_, k)
    error(("sumi: unknown palette color '%s'"):format(k), 2)
  end,
})
