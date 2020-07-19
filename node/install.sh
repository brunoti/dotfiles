if test ! $(which yarn)
then
  if test $(which npm)
  then
    echo "node: installing...";
    npm install yarn -g
    echo "node: installed!";
    echo "";
  else
    echo "node: already installed, skipping...";
  fi
fi
