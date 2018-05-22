## Set visible path in terminal
export PS1='\u@\h: '
## CDPath to Work Directory
CDPATH="/mnt/c/Users/detro/OneDrive/Documents"

## PyEnv Options.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
          eval "$(pyenv init -)"
fi

