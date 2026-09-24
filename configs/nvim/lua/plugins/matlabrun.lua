-- Keep one interactive, terminal based MATLAB process for :MatlabRun.
local matlab_job
local matlab_ready = false
local matlab_queue = {}
local matlab_output = ""

local function matlab_send_next()
  if not matlab_ready or #matlab_queue == 0 or not matlab_job then
    return
  end

  local path = table.remove(matlab_queue, 1)
  -- MATLAB string literals escape apostrophes by doubling them.
  local escaped_path = path:gsub("'", "''")
  matlab_output = ""
  vim.fn.chansend(matlab_job, "run('" .. escaped_path .. "');\n")
  matlab_ready = false
end

local function matlab_run_current()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    vim.notify("MatlabRun needs a file-backed buffer", vim.log.levels.ERROR)
    return
  end

  if vim.bo.modified then
    local ok, err = pcall(vim.cmd, "write")
    if not ok then
      vim.notify("Could not save current buffer: " .. err, vim.log.levels.ERROR)
      return
    end
  end

  -- Queue before starting MATLAB; the startup prompt callback runs the first item.
  table.insert(matlab_queue, path)
  if matlab_job then
    matlab_send_next()
    return
  end

  matlab_job = vim.fn.jobstart({ "matlab", "-nodesktop", "-nosplash" }, {
    pty = true,
    on_stdout = function(_, data)
      if not data then return end
      matlab_output = (matlab_output .. table.concat(data, "\n")):sub(-2048)
      if not matlab_ready and matlab_output:match(">>%s*$") then
        matlab_ready = true
        matlab_send_next()
      end
    end,
    on_exit = function(_, code)
      matlab_job = nil
      matlab_ready = false
      matlab_queue = {}
      matlab_output = ""
      if code ~= 0 then
        vim.schedule(function()
          vim.notify("Headless MATLAB exited with code " .. code, vim.log.levels.ERROR)
        end)
      end
    end,
  })

  if matlab_job <= 0 then
    local code = matlab_job
    matlab_job = nil
    matlab_queue = {}
    vim.notify("Could not start MATLAB (jobstart returned " .. code .. ")", vim.log.levels.ERROR)
  end
end

vim.api.nvim_create_user_command("MatlabRun", matlab_run_current, {
  desc = "Run the current file in a persistent headless MATLAB instance",
})

return {}
