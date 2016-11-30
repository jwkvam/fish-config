# set PATH /Users/jacques/miniconda/bin /Developer/NVIDIA/CUDA-7.0/bin /Users/jacques/.local/bin /usr/local/bin $PATH
set PATH /Users/jacques/miniconda/bin /Users/jacques/.local/bin /usr/local/bin /usr/local/sbin /usr/local/texlive/2016/bin/x86_64-darwin $PATH
#set DYLD_LIBRARY_PATH /Developer/NVIDIA/CUDA-7.0/lib $DYLD_LIBRARY_PATH
set DYLD_FALLBACK_LIBRARY_PATH $DYLD_FALLBACK_LIBRARY_PATH /Users/jacques/miniconda/lib
set -x EDITOR nvim
set -x NVIM_TUI_ENABLE_TRUE_COLOR 1
set -x NVIM_TUI_ENABLE_CURSOR_SHAPE 1


# PYSPARK
set -x PYSPARK_DRIVER_PYTHON jupyter
set -x PYSPARK_DRIVER_PYTHON_OPTS notebook
set -x PYSPARK_PYTHON python


# set -x MACOSX_DEPLOYMENT_TARGET "10.12"
set -x DJANGO_SETTINGS_MODULE apollo.settings.data
set -x PYTHONPATH ~/dev/apollo
set -x PYTHONPATH ~/dev/rover:$PYTHONPATH
set -x PYTHONPATH ~/dev/capcom:$PYTHONPATH
set -x GOPATH ~/.local
# Mac OS X, CPU only, Python 3.4 or 3.5:
set -x TF_BINARY_URL https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-0.12.0rc0-py3-none-any.whl
set -x TF_BINARY_URL_PY2 https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-0.12.0rc0-py2-none-any.whl

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


# function fzf-file-widget
#     set -q FZF_CTRL_T_COMMAND; or set -l FZF_CTRL_T_COMMAND "
#     command find -L . \\( -path '*/\\.*' -o -fstype 'dev' -o -fstype 'proc' \\) -prune \
#       -o -type f -print \
#       -o -type d -print \
#       -o -type l -print 2> /dev/null | sed 1d | cut -b3-"
#     eval "$FZF_CTRL_T_COMMAND | "(__fzfcmd)" -m $FZF_CTRL_T_OPTS > $TMPDIR/fzf.result"
#     and for i in (seq 20); commandline -i (cat /tmp/fzf.result | __fzf_escape) 2> /dev/null; and break; sleep 0.1; end
#     commandline -f repaint
#     rm -f /tmp/fzf.result
# end
#
# function fzf-history-widget
#     history | eval fzf +s +m --tiebreak=index --toggle-sort=ctrl-r $FZF_CTRL_R_OPTS -q '(commandline)' > /tmp/fzf.result
#     and commandline -- (cat /tmp/fzf.result)
#     commandline -f repaint
#     rm -f /tmp/fzf.result
# end


. ~/.config/fish/key-bindings.fish
function fish_user_key_bindings
    bind -M insert \ca beginning-of-line
    bind -M insert \ce end-of-line
    bind -M insert \cf accept-autosuggestion
    bind -M insert \cs forward-bigword forward-word
    fzf_key_bindings
    # bind -M insert \cr history-search-backward
    # bind -M insert \cr fzf-history-widget
end
fish_vi_key_bindings
fish_user_key_bindings


# function hybrid_bindings --description "Vi-style bindings that inherit emacs-style bindings in all modes"
#     for mode in default insert visual
#         fish_default_key_bindings -M $mode
#     end
#     fish_vi_key_bindings --no-erase
# end
# set -g fish_key_bindings hybrid_bindings


# function fish_user_key_bindings
#     fish_vi_key_bindings
#
#     # bind -M insert \ck backward-kill-line
#     bind -M insert \ck kill-whole-line
#     bind -M insert \cl 'clear; commandline -f repaint'
#     bind -M insert \cf accept-autosuggestion
#     bind -M insert \ca beginning-of-line
#     bind -M insert \ce end-of-line
# end

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

function vf
    fzf > /tmp/fzfnv.result; and nvim (cat /tmp/fzfnv.result)
    rm -f /tmp/fzfnv.result
end

function fco
    # set branches (git branch --all | grep -v HEAD             | \
    #               sed "s/.* //"    | sed "s#remotes/[^/]*/##" | \
    #               sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}')
    git branch | sed "s/..//" | fzf > /tmp/fzf.result
    git checkout (cat /tmp/fzf.result)
    rm -f /tmp/fzf.result
end

function fish_right_prompt
  set -l st $status

  if [ $st != 0 ];
    echo (set_color red) ↵ $st(set_color normal)
  end
  echo -n -s $dark_gray '['(date +%H:%M:%S)']'
end

source (conda info --root)/etc/fish/conf.d/conda.fish
. ~/.config/fish/private.fish
