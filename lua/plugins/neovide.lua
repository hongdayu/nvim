if not vim.g.neovide then return {} end
---@param scale_factor number
---@return number
local function clamp_scale_factor(scale_factor)
  return math.max(math.min(scale_factor, vim.g.neovide_max_scale_factor), vim.g.neovide_min_scale_factor)
end

---@param scale_factor number
---@param clamp? boolean
local function set_scale_factor(scale_factor, clamp)
  vim.g.neovide_scale_factor = clamp and clamp_scale_factor(scale_factor) or scale_factor
end

local function reset_scale_factor() vim.g.neovide_scale_factor = vim.g.neovide_initial_scale_factor end

---@param increment number
---@param clamp? boolean
local function change_scale_factor(increment, clamp) set_scale_factor(vim.g.neovide_scale_factor + increment, clamp) end

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      options = {
        opt = {
          guifont = "JetBrainsMono Nerd Font:h13",
          linespace = 0,
        },
        g = {
          terminal_color_0 = "#45475a",
          terminal_color_1 = "#f38ba8",
          terminal_color_2 = "#a6e3a1",
          terminal_color_3 = "#f9e2af",
          terminal_color_4 = "#89b4fa",
          terminal_color_5 = "#f5c2e7",
          terminal_color_6 = "#94e2d5",
          terminal_color_7 = "#bac2de",
          terminal_color_8 = "#585b70",
          terminal_color_9 = "#f38ba8",
          terminal_color_10 = "#a6e3a1",
          terminal_color_11 = "#f9e2af",
          terminal_color_12 = "#89b4fa",
          terminal_color_13 = "#f5c2e7",
          terminal_color_14 = "#94e2d5",
          terminal_color_15 = "#a6adc8",
          neovide_increment_scale_factor = vim.g.neovide_increment_scale_factor or 0.1,
          neovide_min_scale_factor = vim.g.neovide_min_scale_factor or 0.7,
          neovide_max_scale_factor = vim.g.neovide_max_scale_factor or 2.0,
          neovide_initial_scale_factor = vim.g.neovide_scale_factor or 1,
          neovide_scale_factor = vim.g.neovide_scale_factor or 1,
          neovide_show_border = true,
          neovide_refresh_rate = 120,
          neovide_window_blurred = true,
        },
      },
      commands = {
        NeovideSetScaleFactor = {
          function(event)
            local scale_factor, option = tonumber(event.fargs[1]), event.fargs[2]

            if not scale_factor then
              vim.notify(
                "Error: scale factor argument is nil or not a valid number.",
                vim.log.levels.ERROR,
                { title = "Recipe: neovide" }
              )
              return
            end

            set_scale_factor(scale_factor, option ~= "force")
          end,
          nargs = "+",
          desc = "Set Neovide scale factor",
        },
        NeovideResetScaleFactor = {
          reset_scale_factor,
          desc = "Reset Neovide scale factor",
        },
      },
      mappings = {
        n = {
          ["<C-=>"] = {
            function() change_scale_factor(vim.g.neovide_increment_scale_factor * vim.v.count1, true) end,
            desc = "Increase Neovide scale factor",
          },
          ["<C-->"] = {
            function() change_scale_factor(-vim.g.neovide_increment_scale_factor * vim.v.count1, true) end,
            desc = "Decrease Neovide scale factor",
          },
          ["<C-0>"] = { reset_scale_factor, desc = "Reset Neovide scale factor" },
        },
      },
    },
  },
}
