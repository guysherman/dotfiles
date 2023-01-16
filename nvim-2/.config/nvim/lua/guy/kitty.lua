local function get_workspace_name()
  local cwd = vim.fn.getcwd(0)
  local _, workplace_end = string.find(cwd, "workplace/guysnz/" )
  if workplace_end == nil then
    _, workplace_end = string.find(cwd, "workplace/")
  end
  if workplace_end == nil then
    return "default"
  end

  local workplace_relative_path = string.sub(cwd, workplace_end+1)
  local workspace_end, _ = string.find(workplace_relative_path, "/")
  local workspace_name = string.sub(workplace_relative_path, 0, workspace_end-1)

  return workspace_name
end

local function get_vimtest_name()
  local workspace_name = get_workspace_name()
  local vim_test_name = "vim_test_output_"..workspace_name

  return vim_test_name
end

local function kitty_run_namespaced(cmd)
  local window_name = get_vimtest_name()
  local kitty_ls = vim.fn.system("kitty @ ls")
  local i, _ = string.find(kitty_ls, window_name)
  local window_exists = i ~= nil

  if not window_exists then
    vim.fn.system('kitty @ --to \"$KITTY_LISTEN_ON\" launch --type window --keep-focus --title \"' .. window_name .. "\" \"$SHELL\"")
  end

  vim.fn.system('kitty @ --to \"$KITTY_LISTEN_ON\" send-text --match title:\"' .. window_name .. "\" \"" .. cmd .. "\\x0d\"")
  vim.fn.system('kitty @ --to \"$KITTY_LISTEN_ON\" focus-window --match title:\"' .. window_name .. " --no-response")
end

return {
  GetVimTestName = get_vimtest_name,
  KittyRunNamespaced = kitty_run_namespaced
}

