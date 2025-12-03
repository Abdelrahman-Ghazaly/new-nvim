return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    picker = {
      layout = "ivy_split",
      matcher = {
        frecency = true,
      },
    },
  },

  keys = {
    { "<leader>sf", function() require("snacks").picker.files() end,  desc = "Find Files" },
    { "<leader>sg", function() require("snacks").picker.grep() end,   desc = "Grep Text" },
    { "<leader>sc", function() require("snacks").picker.lines() end,  desc = "Search in Buffer" },
    { "<leader>sh", function() require("snacks").picker.help() end,   desc = "Help" },
    { "<leader>sr", function() require("snacks").picker.resume() end, desc = "Resume Search" },
  },
}
