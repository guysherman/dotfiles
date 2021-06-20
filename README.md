# Dotfiles

To bootstrap a machine:

Open this repo in your browser, and run the following command in a terminal, from your home directory:

```
rm -fr main.zip* && rm -rf dotfiles && wget https://github.com/guysherman/dotfiles/archive/refs/heads/main.zip \
  && unzip main.zip && mv dotfiles-main dotfiles && chmod +x dotfiles/bootstrap.sh \
  && rm -rf main.zip && cd dotfiles
```
