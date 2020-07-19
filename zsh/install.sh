if ! test -d $HOME/.oh-my-zsh
then
  echo "oh-my-zsh: installing...";
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "oh-my-zsh: installed with success";
  echo "";
else
  echo "oh-my-zsh: already installed skipping...";
  echo "";
fi
