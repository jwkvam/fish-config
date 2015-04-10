set PATH /Users/jacques/miniconda/bin /Developer/NVIDIA/CUDA-7.0/bin /Users/jacques/.local/bin /usr/local/bin $PATH
set DYLD_LIBRARY_PATH /Developer/NVIDIA/CUDA-7.0/lib $DYLD_LIBRARY_PATH
set EDITOR vi
set NVIM_TUI_ENABLE_TRUE_COLOR 1

set -x PYTHONPATH ~/dev/apollo

set -x DJANGO_SETTINGS_MODULE apollo.settings.data

alias sshb="ssh jacques@10.10.10.127"
alias git="hub"

alias ff="find . -name"
function vi
    set -x -l PATH /usr/bin $PATH 2> /dev/null
    # echo $PATH
    /usr/local/bin/nvim $argv
end


alias i=ipython
alias pyld="pylint --load-plugins pylint_django"

function fish_user_key_bindings
    fish_vi_key_bindings

    # bind -M insert \ck backward-kill-line
    bind -M insert \ck kill-whole-line
    bind -M insert \cl 'clear; commandline -f repaint'
    bind -M insert \cf accept-autosuggestion
    bind -M insert \ca beginning-of-line
    bind -M insert \ce end-of-line
end

. /Users/jacques/.config/fish/jenv.fish
. /Users/jacques/.config/fish/j.fish
. /Users/jacques/.config/fish/conda.fish
. /Users/jacques/.config/fish/functions/fzf.fish
. /Users/jacques/.config/fish/functions/fzf_wrap.fish

. /Users/jacques/.config/fish/informative_git.fish
