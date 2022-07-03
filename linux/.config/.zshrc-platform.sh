export KITTYMUX_STATE_DIR=$HOME/.local/state

# virtualenv and virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/local/bin/virtualenvwrapper.sh

export GOPATH=/opt/go

export PATH=$GOPATH/bin:$PATH

# jEnv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# Maven
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH="$MAVEN_HOME/bin:$PATH"

# Completion for kitty
kitty + complete setup zsh | source /dev/stdin
