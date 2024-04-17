function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting

end

starship init fish | source
set -x PATH $HOME/miniconda3/bin $PATH

# function fish_prompt
#   set_color cyan; echo (pwd) 
#   set_color green; echo '> '
# end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/shah/miniconda3/bin/conda
    eval /home/shah/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/shah/miniconda3/etc/fish/conf.d/conda.fish"
        . "/home/shah/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/shah/miniconda3/bin" $PATH
    end
end
# <<< conda initialize <<<

