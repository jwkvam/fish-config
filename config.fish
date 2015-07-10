set PATH /Users/jacques/miniconda/bin /Developer/NVIDIA/CUDA-7.0/bin /Users/jacques/.local/bin /usr/local/bin $PATH
set DYLD_LIBRARY_PATH /Developer/NVIDIA/CUDA-7.0/lib $DYLD_LIBRARY_PATH
set DYLD_FALLBACK_LIBRARY_PATH $DYLD_FALLBACK_LIBRARY_PATH /Users/jacques/miniconda/lib
set EDITOR vi
set NVIM_TUI_ENABLE_TRUE_COLOR 1

set -x PYTHONPATH ~/dev/apollo

set -x DJANGO_SETTINGS_MODULE apollo.settings.data

alias sshb="ssh jacques@10.10.10.127"
# alias git="hub"

alias ff="find . -name"
alias vi="nvim"

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

function -e fish_preexec _run_fasd
    # fasd --proc (fish_split (fasd --sanitize $argv)) > /dev/null 2>&1
    fasd --proc (fasd --sanitize $argv | tr -s ' ' \n) > /dev/null 2>&1
end

function j
    set -l dir (fasd -de "printf %s" "$argv")
    if test "$dir" = ""
        echo "no matching directory"
        return 1
    end
    cd $dir
end

function e
    fasd -fe vim "$argv"
end

. /Users/jacques/.config/fish/jenv.fish
# . /Users/jacques/.config/fish/j.fish
. /Users/jacques/.config/fish/conda.fish
. /Users/jacques/.config/fish/functions/fzf.fish
. /Users/jacques/.config/fish/functions/fzf_wrap.fish

. /Users/jacques/.config/fish/informative_git.fish
