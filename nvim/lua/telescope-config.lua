local mappings = {
    n = {
        ["cd"] = function(prompt_bufnr)
            local selection = require("telescope.actions.state").get_selected_entry()
            local dir = vim.fn.fnamemodify(selection.path, ":p:h")
            require("telescope.actions").close(prompt_bufnr)
            vim.cmd(string.format("silent lcd %s", dir))
        end
    }
}

require("telescope").setup {
    pickers = {
        find_files = {
            mappings = mappings
        },
    }
}
