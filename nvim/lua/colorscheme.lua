-- 定义你要使用的配色方案名称
local colorscheme = 'monokai_pro' -- 替换为你喜欢的配色方案名称

-- 尝试加载配色方案
local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

-- 检查加载是否成功
if not is_ok then
    -- 如果加载失败，通知用户并提示错误
    vim.notify('配色方案 ' .. colorscheme .. ' 未找到！', vim.log.levels.ERROR)
    return
end