-- lsp: Zig (zls)
--

return {
    cmd = { "zls" },
    filetypes = { "zig", "zir" },
    root_markers = { "build.zig", "zls.json", ".git" },
    settings = {
        zls = {
            enable_build_on_save = true,
            enable_snippets = true,
            enable_argument_placeholders = true,
            completion_label_details = true,

            semantic_tokens = "full",

            -- Inlay hints
            inlay_hints_show_variable_type_hints = true,
            inlay_hints_show_parameter_name = true,
            inlay_hints_show_builtin = true,
            inlay_hints_exclude_single_argument = true,
            inlay_hints_hide_redundant_param_names = true,
            inlay_hints_hide_redundant_param_names_last_token = true,

            -- Optional quality-of-life
            warn_style = true,
            highlight_global_var_declarations = true,
        },
    },
}
