# sumi — Neovim colorscheme

A single dark colorscheme matched to the rest of the desktop (GTK theme, i3, rofi, dunst). Syntax colors derive from Ayu Dark.
Neovim 0.12+. No dependencies.

This file is the design reference. Read it before changing colors or adding groups.

## Location

This folder lives at `~/.config/nvim/lua/themes/sumi/`, so its Lua module name is `themes.sumi`.
The code takes its module name from wherever it is required, so the folder can be moved or
renamed; only `colors/sumi.lua` and the `require()` calls below need the new name.

```
~/.config/nvim/
├── colors/sumi.lua           require("themes.sumi").load()   ← entry point for :colorscheme sumi
└── lua/themes/sumi/          this folder
    ├── README.md             this file
    ├── init.lua              loader + compiler + cache
    ├── palette.lua           EVERY color, named by role. The only file with hex values.
    └── groups/               one file per scope; each returns function(c) -> { Group = spec }
        ├── editor.lua        built-in UI: windows, gutter, statusline, popups, search, diff, spell
        ├── syntax.lua        legacy Vim syntax groups (Comment, String, ...)
        ├── treesitter.lua    base @captures shared by all languages
        ├── lsp.lua           diagnostics, LSP UI, semantic tokens (linked to @captures)
        ├── languages/        @capture.<lang> overrides: markdown.lua, git.lua
        └── plugins/          plugin highlight groups: blink.lua, gitsigns.lua, fzf.lua, oil.lua
```

`colors/sumi.lua` is a single line and stays outside this folder on purpose: `:colorscheme sumi`
needs it, and `:colorscheme` fires the `ColorScheme` event that plugins (fzf-lua, gitsigns, ...)
use to re-apply their own defaults for groups the theme doesn't define.

Every `.lua` file under `groups/` is picked up automatically. Load order doesn't matter: a group
may be defined in only one file (defining it twice is a compile error naming both files).

## Setup

In `init.lua`:

```lua
vim.cmd.colorscheme("sumi")
vim.o.winborder = "rounded" -- floats are drawn on the editor background; the border separates them

vim.api.nvim_create_user_command("SumiCompile", function()
  local path, count = require("themes.sumi").compile()
  vim.notify(("sumi: compiled %d groups to %s"):format(count, path))
end, {})
```

## API and cache

| Call | Does |
|---|---|
| `require("themes.sumi").load()` | Applies the theme. Recompiles first if any file in this folder is newer than the cache. |
| `require("themes.sumi").compile()` | Rebuilds the cache now, re-applies if sumi is active. Returns `path, group_count`. |
| `require("themes.sumi.palette")` | The color table, for your own statusline, winbar, etc. |

Compiling runs every group file against the palette and writes one file of `nvim_set_hl()` calls
to `stdpath("cache")/sumi/sumi.lua` (readable, if you want to see the final result). Loading only
runs that file (~1.5 ms; a full compile is ~6 ms).

- Editing, adding or deleting any file in this folder triggers a rebuild on the next start, so
  `:SumiCompile` is only needed to see changes in the running session.
- If an edit breaks compilation, startup keeps using the last good cache and shows the error.
- Using a color name that isn't in `palette.lua` is an error (`unknown palette color 'x'`),
  so typos never silently produce uncolored groups.

## Design system

### Principles

1. **One dark variant.** No light theme, no style switches. The one option is
   `palette.transparent`.
2. **Color carries meaning.** Syntax uses Ayu Dark's mapping; UI is neutral grey with a single
   blue accent. State (error/warn/info/hint/ok) and version control (added/changed/removed)
   have fixed colors used everywhere.
3. **Quiet surfaces.** Backgrounds are near-black greys with only a slight blue tint. Tinted
   backgrounds (diff, search, virtual text) are the state color mixed 12–35% into `bg`, never
   saturated blocks.
4. **Minimal emphasis.** Italic only for comments (and `@markup.italic`, quotes). Bold only for
   the cursor line number, titles/headings, the current search match, and completion matches.
5. **Never hex in group files.** Group files use `c.<role>` only. A new color is a new palette
   entry with a role comment.

### Surfaces (darkest → lightest)

| Role | Hex | Use |
|---|---|---|
| `bg_dark` | `#0c0e11` | inactive statusline, tabline fill, float shadow |
| `bg` | `#111316` | editor, floats, sidebars, pickers |
| `bg_alt` | `#16181d` | cursorline, statusline, completion menu, inline code, inlay hints |
| `bg_raised` | `#22242a` | LSP references, scrollbar thumbs, matching paren |
| `border` | `#2a2d34` | float/window borders, separators |
| `guide` | `#34373e` | whitespace, listchars, table pipes |

Floats share `bg` with the editor and are separated by `border` (set `winborder`). Menus
(`Pmenu`, blink.cmp) use `bg_alt` so they still read when a plugin draws no border.

### Text

| Role | Hex | Use |
|---|---|---|
| `fg_bright` | `#f1f1f1` | cursor line number, titles, commit summary |
| `fg` | `#bebdb9` | default text, variables |
| `fg_muted` | `#959699` | punctuation, secondary text, quotes |
| `comment` | `#5f636e` | comments, disabled/inactive, details in menus |
| `dim` | `#4f545d` | line numbers, ghost text, inlay hints, blame |

### Accent and selection

| Role | Hex | Use |
|---|---|---|
| `accent` | `#0a84c6` | focus markers (fzf pointer); the desktop-wide accent |
| `accent_hi` | `#59c2ff` | accent as text: links, directories, matches, prompts |
| `on_accent` | `#0c0e11` | text on top of strong backgrounds (current search match) |
| `sel` | `#1b374d` | visual selection, selected menu/picker item, quickfix line |
| `search` | `#263332` | search matches (teal tint, distinct from selection) |

Current search match (`CurSearch`) is `func` background with `on_accent` text: the one
deliberately loud element.

### Syntax (Ayu Dark)

| Role | Hex | Tokens |
|---|---|---|
| `keyword` | `#ff8f40` | keywords, control flow, imports, storage, preprocessor, list bullets |
| `func` | `#ffb454` | functions, methods, macros (as functions), TODO |
| `string` | `#aad94c` | strings, characters, paths |
| `regexp` | `#95e6cb` | regex, escapes, inline code, math |
| `constant` | `#d2a6ff` | numbers, booleans, constants, enum members, symbols |
| `type` | `#59c2ff` | types, classes, constructors, interfaces |
| `tag` | `#39bae6` | modules/namespaces, `self`/`this`, HTML tags, diff hunk headers |
| `special` | `#e6c08a` | parameters, attributes/decorators, tag attributes, special strings |
| `operator` | `#f29668` | operators, ternary |
| `member` | `#f07178` | fields, properties, generic markup headings |

Punctuation (brackets, delimiters) is `fg_muted` so code structure recedes behind content.

### State and version control

| Role | Hex | | Role | Hex |
|---|---|---|---|---|
| `error` | `#f07178` | | `added` | `#70bf56` |
| `warn` | `#ffb454` | | `changed` | `#73b8ff` |
| `info` | `#59c2ff` | | `removed` | `#f26d78` |
| `hint` | `#95e6cb` | | | |
| `ok` | `#aad94c` | | | |

Diagnostics: text and signs in the state color; virtual text adds the matching `*_bg` tint;
underlines are undercurls with `sp` set to the state color. Diff lines use `diff_add`,
`diff_change`, `diff_delete`; the changed part of a line uses `diff_text`.

Tinted backgrounds were made by mixing the state color into `bg` in OKLab
(`diff_*` ≈ 16%, `diff_text` ≈ 30%, `*_bg` ≈ 10%, `sel` = accent ≈ 35%). Keep new tints in
the same range so they stay readable under text.

### Terminal

`palette.term` is the 16-color palette for `:terminal`, identical to the Alacritty config:
black `#0c0e11`, red `#f07178`, green `#aad94c`, yellow `#ffb454`, blue `#59c2ff`,
magenta `#d2a6ff`, cyan `#39bae6`, white `#bebdb9`; bright black `#5f636e`, bright white `#f1f1f1`.

## Extending

### Adding a plugin

1. Find its highlight group names in the plugin's source or docs, e.g.
   `grep -rhoE "nvim_set_hl\(0, ['\"][A-Za-z]+" lua/` or the "highlight" section of its help file.
   Plugins usually define defaults with `default = true`, so anything you define wins.
2. Create `groups/plugins/<plugin>.lua`:
   ```lua
   -- author/plugin.nvim
   return function(c)
     return {
       PluginNormal   = { fg = c.fg, bg = c.bg },
       PluginBorder   = { fg = c.border, bg = c.bg },
       PluginSelected = { bg = c.sel },
       PluginMatch    = { fg = c.accent_hi, bold = true },
     }
   end
   ```
3. Map by role, not by look: windows → surfaces/`border`; selected item → `sel`; matches →
   `accent_hi` bold; added/removed → `added`/`removed`; anything code-like → the syntax roles.
   Prefer `{ link = "CoreGroup" }` when the plugin's group means the same thing as a core group.
4. Restart, or run `:SumiCompile`.

Covered now: blink.cmp, gitsigns, fzf-lua, oil, nvim-treesitter (via base captures).
nvim-autopairs, conform.nvim and nvim-lint define no groups of their own: autopairs' fast-wrap
uses `Search`/`Comment`, lint results are diagnostics. fzf-lua's `FzfLuaFzf*` groups only apply
with `fzf_colors = true`; colors inside grep results (paths, matches) come from `rg --colors`
and the terminal palette. gitsigns' `GitSignsStaged*` groups are left undefined on purpose:
gitsigns derives them by dimming the unstaged colors.

### Adding a language

Base captures in `treesitter.lua` already cover every language. Add a language file only when
a language needs something different:

1. Put the cursor on the token and run `:Inspect` to see its capture, e.g. `@variable.builtin.php`.
2. Create `groups/languages/<lang>.lua` returning `{ ["@capture.<lang>"] = { ... } }`.
   The parser name is the suffix (`php`, `cpp`, `typescript`, `tsx`, `markdown_inline`, ...).
3. Queries live in nvim-treesitter's `runtime/queries/<lang>/highlights.scm` if you need the
   full list of captures a language uses.

Existing: `markdown.lua` (table headers, quiet code fences and pipes, inline code),
`git.lua` (gitcommit, git_rebase, diff — treesitter plus legacy groups used by fugitive).

### Changing a color

Edit `palette.lua` only. Every group using that role follows. If one group needs a different
color than its role gives, that's a sign a new role is needed: add it to the palette with a
comment, then use it.

## Using the palette in your own config

```lua
local c = require("themes.sumi.palette")
vim.api.nvim_set_hl(0, "StatusLineMode", { fg = c.on_accent, bg = c.accent, bold = true })
vim.api.nvim_set_hl(0, "StatusLineGit",  { fg = c.added, bg = c.bg_alt })
```

Groups you define in your config aren't part of the cache, so set them after
`colorscheme sumi` (or in a `ColorScheme` autocmd).
