
  echo "# Map over our bash/zsh files"
  
  if [ -f ~/.bash_logout ]
  then
    mv ~/.bash_logout ~/.bash_logout.old
  fi
    
  if [ -f ~/.bashrc ]
  then
    mv ~/.bashrc ~/.bashrc.old
  fi
  
  
  if [ -f ~/.zshrc ]
  then
    mv ~/.zshrc ~/.zshrc.old
  fi

  if [ -f ~/.dir_colors ]
  then
    mv ~/.dir_colors ~/.dir_colors.old
  fi



  ln -s `pwd`/.bash_logout `echo ~`/.bash_logout
  ln -s `pwd`/.bashrc `echo ~`/.bashrc
  ln -s `pwd`/.zshrc `echo ~`/.zshrc
  ln -s `pwd`/.dir_colors `echo ~`/.dir_colors

