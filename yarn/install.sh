if test ! $(which yarn)
then
  if test ! $(which trash)
  then
    echo "yarn: installing trash-cli...";
    yarn global add trash-cli
    echo "yarn: installed trash-cli!";
    echo "";
  else
    echo "yarn: trash-cli installed, skipping...";
    echo "";
  fi
fi
