set PATH /usr/local/bin /usr/local/sbin $PATH
if contains (uname) "Linux"
    set PATH ~/.linuxbrew/bin ~/.linuxbrew/sbin /usr/local/cuda/bin $PATH
    set BREW_PREFIX $HOME/.linuxbrew
else
    set PATH /usr/local/texlive/2016/bin/x86_64-darwin $PATH
    if test -d /usr/local/cuda/bin
        set PATH /usr/local/cuda/bin $PATH
    end
    set BREW_PREFIX /usr/local
    set -x DYLD_LIBRARY_PATH /usr/local/cuda/lib /usr/local/cuda /usr/local/cuda/extras/CUPTI/lib
    set -x LD_LIBRARY_PATH $DYLD_LIBRARY_PATH
    set PATH $DYLD_LIBRARY_PATH $PATH
end
set PATH ~/miniconda/bin $PATH
source (conda info --root)/etc/fish/conf.d/conda.fish
set PATH ~/.local/bin $PATH
#set DYLD_LIBRARY_PATH /Developer/NVIDIA/CUDA-7.0/lib $DYLD_LIBRARY_PATH
set DYLD_FALLBACK_LIBRARY_PATH $DYLD_FALLBACK_LIBRARY_PATH /Users/jacques/miniconda/lib
if contains (uname) "Linux"
    set LD_LIBRARY_PATH /usr/local/cuda/lib64
end
set -x EDITOR nvim
set -x NVIM_TUI_ENABLE_TRUE_COLOR 1

# PYSPARK
set -x PYSPARK_DRIVER_PYTHON jupyter
set -x PYSPARK_DRIVER_PYTHON_OPTS notebook
set -x PYSPARK_PYTHON python

set -x DJANGO_SETTINGS_MODULE apollo.settings.data
set -x PYTHONPATH ~/dev/rover
set -x PYTHONPATH ~/dev/apollo:$PYTHONPATH
# set -x PYTHONPATH ~/dev/capcom:$PYTHONPATH
set -x GOPATH ~/.local

# don't generate pyc files
set -x PYTHONDONTWRITEBYTECODE 1

# set -x FZF_DEFAULT_COMMAND 'rg --files'
# https://github.com/BurntSushi/ripgrep/issues/340
set -x FZF_DEFAULT_COMMAND "rg -L --files --hidden -g '!.git'"
set -x FZF_DEFAULT_OPTS "--inline-info"

set -x FZF_CTRL_T_COMMAND "rg -L --files --hidden -g '!.git'"

# great material here!
# https://github.com/junegunn/dotfiles/blob/master/bashrc
set -x FZF_CTRL_T_OPTS '--preview "highlight --failsafe -O ansi {} 2> /dev/null | head -200"'

alias rgs=rg
alias rg="rg -S"
alias sshb="ssh jacques@harmonic.local"
alias ff="find . -name"
alias vi="nvim"
alias v="nvim"
alias magit="nvim -c MagitOnly"
alias pag="ps aux | rg -N"
alias pug="ps ux | rg -N"

# I always forget the dot
alias pytest='py.test'
alias i=ipython

# . ~/.config/fish/key-bindings.fish
. ~/.config/fish/functions/fzf_key_bindings.fish
 
# /usr/local/Cellar/fish/2.6.0/share/doc/fish/commands.html
function fzf-nvim-file-widget -d "List files and folders"
    eval "$FZF_CTRL_T_COMMAND | "(__fzfcmd)" -m $FZF_CTRL_T_OPTS" | while read -l r; set result $result $r; end
    commandline -f repaint
    if [ -n "$result" ]
        nvim $result
    end
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

alias cdw=fzf-cd-widget

[ -f $BREW_PREFIX/share/autojump/autojump.fish ]; and source $BREW_PREFIX/share/autojump/autojump.fish

# function vf
#     fzf > /tmp/fzfnv.result; and nvim (cat /tmp/fzfnv.result)
#     rm -f /tmp/fzfnv.result
# end

function fbr
    git branch | sed "s/..//" | fzf > /tmp/fzf.result
    git checkout (cat /tmp/fzf.result)
    rm -f /tmp/fzf.result
end

function up -d 'cd backwards'
    pwd | awk -v RS=/ '/\n/ {exit} {p=p $0 "/"; print p}' | gtac | eval (__fzfcmd) +m --select-1 --exit-0 $FZF_BCD_OPTS | read -l result
    [ "$result" ]; and cd $result
    commandline -f repaint
end

function cdhist -d 'cd to one of the previously visited locations'
    # Clear non-existent folders from cdhist.
    set -l buf
    for i in (seq 1 (count $dirprev))
        set -l dir $dirprev[$i]
        if test -d $dir
            set buf $buf $dir
        end
    end
    set dirprev $buf
    string join \n $dirprev | gtac | sed 1d | eval (__fzfcmd) +m $FZF_CDHIST_OPTS | read -l result
    [ "$result" ]; and cd $result
    commandline -f repaint
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

if test -e ~/.config/fish/private.fish
    . ~/.config/fish/private.fish
end
