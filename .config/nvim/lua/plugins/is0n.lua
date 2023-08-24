return {
  {
    "is0n/fm-nvim",
    config = function()
      require("fm-nvim").setup({
        cmds = {
          fzf_cmd = "fzf --reverse --preview 'bat --color=always {}'",
          skim_cmd = "sk --reverse --preview 'bat --color=always {}'",
        },
      })
    end,
  },
}
