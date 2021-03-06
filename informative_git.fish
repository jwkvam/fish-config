# name: Informative Git Prompt
# author: Mariusz Smykula <mariuszs at gmail.com>

set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_hide_untrackedfiles 1

set -g __fish_git_prompt_color_branch magenta --bold
set -g __fish_git_prompt_showupstream "informative"
set -g __fish_git_prompt_char_upstream_ahead "↑"
set -g __fish_git_prompt_char_upstream_behind "↓"
set -g __fish_git_prompt_char_upstream_prefix ""

set -g __fish_git_prompt_char_stagedstate "●"
set -g __fish_git_prompt_char_dirtystate "✚"
set -g __fish_git_prompt_char_untrackedfiles "…"
set -g __fish_git_prompt_char_conflictedstate "✖"
set -g __fish_git_prompt_char_cleanstate "✔"

set -g __fish_git_prompt_color_dirtystate blue
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
set -g __fish_git_prompt_color_cleanstate green --bold

function fish_vi_prompt_cm --description "Displays the current mode"
  echo -n " "
  switch $fish_bind_mode
    case default
      set_color --bold --background red white
      echo "[N]"
    case insert
      set_color --bold --background green white
      echo "[I]"
    case visual
      set_color --bold --background magenta white
      echo "[V]"
  end
  set_color normal
end

function fish_right_prompt
  set -l st $status

  if [ $st != 0 ];
    echo (set_color red) ↵ $st(set_color normal)
  end
  echo -n -s $dark_gray ' ['(date +%H:%M:%S)'] '
end

function fish_prompt --description 'Write out the prompt'

	set -l last_status $status

	if not set -q __fish_prompt_normal
		set -g __fish_prompt_normal (set_color normal)
	end

	# PWD
	set_color $fish_color_cwd
	echo -n (prompt_pwd)
	set_color normal

	printf '%s' (__fish_git_prompt)
	printf '%s' (fish_vi_prompt_cm)

	if not test $last_status -eq 0
	set_color $fish_color_error
	end

	echo -n ' ∫ '

	set_color normal
end
