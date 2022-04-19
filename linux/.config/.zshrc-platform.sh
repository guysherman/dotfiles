export PATH=/opt/go/bin:$PATH

# jEnv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# Maven
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH="$MAVEN_HOME/bin:$PATH"
