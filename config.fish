# set PATH /Users/jacques/miniconda/bin /Developer/NVIDIA/CUDA-7.0/bin /Users/jacques/.local/bin /usr/local/bin $PATH
# set PATH /Users/jacques/miniconda/bin /Users/jacques/.local/bin /usr/local/bin /usr/local/sbin /usr/local/texlive/2016/bin/x86_64-darwin $PATH
set PATH ~/miniconda/bin ~/.local/bin /usr/local/bin /usr/local/sbin $PATH
if contains (uname) "Linux"
    set PATH ~/.linuxbrew/bin /usr/local/cuda/bin $PATH
else
    set PATH /usr/local/texlive/2016/bin/x86_64-darwin $PATH
end
#set DYLD_LIBRARY_PATH /Developer/NVIDIA/CUDA-7.0/lib $DYLD_LIBRARY_PATH
set DYLD_FALLBACK_LIBRARY_PATH $DYLD_FALLBACK_LIBRARY_PATH /Users/jacques/miniconda/lib
if contains (uname) "Linux"
    set LD_LIBRARY_PATH /usr/local/cuda/lib64
end
set -x EDITOR nvim
set -x NVIM_TUI_ENABLE_TRUE_COLOR 1
set -x NVIM_TUI_ENABLE_CURSOR_SHAPE 1


# PYSPARK
set -x PYSPARK_DRIVER_PYTHON jupyter
set -x PYSPARK_DRIVER_PYTHON_OPTS notebook
set -x PYSPARK_PYTHON python

set -x DJANGO_SETTINGS_MODULE apollo.settings.data
set -x PYTHONPATH ~/dev/apollo
set -x PYTHONPATH ~/dev/rover:$PYTHONPATH
# set -x PYTHONPATH ~/dev/capcom:$PYTHONPATH
set -x GOPATH ~/.local

# don't generate pyc files
set -x PYTHONDONTWRITEBYTECODE 1

set -x FZF_DEFAULT_COMMAND 'rg --files'
set -x FZF_DEFAULT_OPTS "--inline-info"

set -x FZF_CTRL_T_COMMAND 'rg --files'

# great material here!
# https://github.com/junegunn/dotfiles/blob/master/bashrc
set -x FZF_CTRL_T_OPTS '--preview "highlight --failsafe -O ansi {} 2> /dev/null | head -200"'

alias rgs=rg
alias rg="rg -S"
alias sshb="ssh jacques@harmonic.local"
alias ff="find . -name"
alias vi="nvim"
alias magit="nvim -c MagitOnly"
alias pag="ps aux | rg -N"
alias pug="ps ux | rg -N"

# I always forget the dot
alias pytest='py.test'
alias i=ipython

# . ~/.config/fish/key-bindings.fish
. ~/.config/fish/functions/fzf_key_bindings.fish
 
# Store last token in $dir as root for the 'find' command
function fzf-nvim-file-widget -d "List files and folders"
    set -l dir (commandline -t)
    # The commandline token might be escaped, we need to unescape it.
    set dir (eval "printf '%s' $dir")
    if [ ! -d "$dir" ]
      set dir .
    end
    # Some 'find' versions print undesired duplicated slashes if the path ends with slashes.
    set dir (string replace --regex '(.)/+$' '$1' "$dir")

    # "-path \$dir'*/\\.*'" matches hidden files/folders inside $dir but not
    # $dir itself, even if hidden.
    set -q FZF_CTRL_T_COMMAND; or set -l FZF_CTRL_T_COMMAND "
    command find -L \$dir \\( -path \$dir'*/\\.*' -o -fstype 'devfs' -o -fstype 'devtmpfs' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | sed '1d; s#^\./##'"

    eval "$FZF_CTRL_T_COMMAND | "(__fzfcmd)" -m $FZF_CTRL_T_OPTS" | while read -l r; set result $result $r; end
    nvim $result
    commandline -f repaint
end

function fish_user_key_bindings
    bind -M insert \ca beginning-of-line
    bind -M insert \ce end-of-line
    bind -M insert \cf accept-autosuggestion
    bind -M insert \cs forward-bigword forward-word
    fzf_key_bindings

    bind \cg fzf-cd-widget
    bind -M insert \cg fzf-cd-widget
    bind \co fzf-nvim-file-widget
    bind -M insert \co fzf-nvim-file-widget
    # bind -M insert \cr history-search-backward
    # bind -M insert \cr fzf-history-widget
end
fish_vi_key_bindings
fish_user_key_bindings




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

# function vf
#     fzf > /tmp/fzfnv.result; and nvim (cat /tmp/fzfnv.result)
#     rm -f /tmp/fzfnv.result
# end

function fbr
    git branch | sed "s/..//" | fzf > /tmp/fzf.result
    git checkout (cat /tmp/fzf.result)
    rm -f /tmp/fzf.result
end

function fish_prompt
    # https://github.com/fish-shell/fish-shell/blob/master/share/tools/web_config/sample_prompts/informative_vcs.fish
    if not set -q __fish_git_prompt_show_informative_status
        set -g __fish_git_prompt_show_informative_status 1
    end
    if not set -q __fish_git_prompt_hide_untrackedfiles
        set -g __fish_git_prompt_hide_untrackedfiles 1
    end

    if not set -q __fish_git_prompt_color_branch
        set -g __fish_git_prompt_color_branch magenta --bold
    end
    if not set -q __fish_git_prompt_showupstream
        set -g __fish_git_prompt_showupstream "informative"
    end
    if not set -q __fish_git_prompt_char_upstream_ahead
        set -g __fish_git_prompt_char_upstream_ahead "↑"
    end
    if not set -q __fish_git_prompt_char_upstream_behind
        set -g __fish_git_prompt_char_upstream_behind "↓"
    end
    if not set -q __fish_git_prompt_char_upstream_prefix
        set -g __fish_git_prompt_char_upstream_prefix ""
    end

    if not set -q __fish_git_prompt_char_stagedstate
        set -g __fish_git_prompt_char_stagedstate "●"
    end
    if not set -q __fish_git_prompt_char_dirtystate
        set -g __fish_git_prompt_char_dirtystate "✚"
    end
    if not set -q __fish_git_prompt_char_untrackedfiles
        set -g __fish_git_prompt_char_untrackedfiles "…"
    end
    if not set -q __fish_git_prompt_char_conflictedstate
        set -g __fish_git_prompt_char_conflictedstate "✖"
    end
    if not set -q __fish_git_prompt_char_cleanstate
        set -g __fish_git_prompt_char_cleanstate "✔"
    end

    if not set -q __fish_git_prompt_color_dirtystate
        set -g __fish_git_prompt_color_dirtystate blue
    end
    if not set -q __fish_git_prompt_color_stagedstate
        set -g __fish_git_prompt_color_stagedstate yellow
    end
    if not set -q __fish_git_prompt_color_invalidstate
        set -g __fish_git_prompt_color_invalidstate red
    end
    if not set -q __fish_git_prompt_color_untrackedfiles
        set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
    end
    if not set -q __fish_git_prompt_color_cleanstate
        set -g __fish_git_prompt_color_cleanstate green --bold
    end

    if not set -q __fish_prompt_normal
        set -g __fish_prompt_normal (set_color normal)
    end

    set -l color_cwd
    set -l prefix
    switch $USER
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set suffix '$'
    end

    # host
    set_color $fish_color_host
    set host (hostname | cut -c1-3)
    echo -n "$host "
    set_color normal

    # PWD
    set_color $color_cwd
    echo -n (prompt_pwd)
    set_color normal

    printf '%s ' (__fish_vcs_prompt)

    echo -n "$suffix "

    set_color normal

end

function fish_right_prompt
  set -l st $status

  if [ $st != 0 ];
    echo (set_color red) ↵ $st(set_color normal)
  end
  echo -n -s $dark_gray '['(date +%H:%M:%S)']'
end

source (conda info --root)/etc/fish/conf.d/conda.fish
if test -e ~/.config/fish/private.fish
    . ~/.config/fish/private.fish
end
