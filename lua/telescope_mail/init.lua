local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local config = require('telescope.config').values
local previewers = require 'telescope.previewers'

local M = {}

M.show_mails = function(opts)
  pickers
    .new(opts, {
      finder = finders.new_oneshot_job({
        'bash',
        '-c',
        "himalaya list -s 100 -o json | jq -c '.[]'",
      }, {
        entry_maker = function(entry)
          local parsed = vim.json.decode(entry)
          if parsed then
            return {
              value = parsed,
              display = parsed.subject,
              ordinal = parsed.subject,
            }
          end
        end,
      }),
      sorter = config.generic_sorter(opts),
      previewer = previewers.new_buffer_previewer {
        title = 'E-Mail details',
        define_preview = function(self, entry)
          if entry then
            vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 0, true, { entry.value.id, entry.value.subject, entry.value.from.addr })
          end
        end,
      },
    })
    :find()
end

return M
