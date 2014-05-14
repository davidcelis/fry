# Set defaults
set -q fry_rubies       ; or set -U fry_rubies $HOME/.rubies
set -q fry_auto_switch  ; or set -U fry_auto_switch 0
if not set -q fry_installer
  for command in ruby-build ruby-install
    test (which $command); and set -U fry_installer $command
  end
end

test -d $fry_rubies; or mkdir -p $fry_rubies

# Path
set -l fry_path (dirname (status -f))

if not contains $fry_path/functions $fish_function_path
  set fish_function_path $fry_path/functions $fish_function_path
end

if not contains $fry_path/completions $fish_complete_path
  set fish_complete_path $fry_path/completions $fish_complete_path
end

# Auto-switch
function __fry_auto_switch_toggle --on-variable fry_auto_switch
  if test $fry_auto_switch = 1
    function __fry_auto_switch --on-variable PWD --description 'Auto-switch ruby version from .ruby-version file'
      status --is-command-substitution; and return

      set -l version_file (__fry_find_version_file)
      test -n "$version_file"; or return

      set -l version_data (cat $version_file)
      test -n "$version_data"; or return

      fry use $version_data >/dev/null
    end

    __fry_auto_switch
  else
    functions -e __fry_auto_switch
  end
end

__fry_auto_switch_toggle
