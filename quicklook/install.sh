if test ! "$(uname)" = "Darwin"
  then
  exit 0
fi

if test $(which brew)
then
  if [[ ! -d $HOME/Library/QuickLook/QLMarkdown.qlgenerator ]]
  then
    echo "";
    echo "quicklook: installing plugins from sindreshorhus...";
    brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize suspicious-package quicklookase qlvideo;
    echo "quicklook: making it work on Catalanina...";
    xattr -d -r com.apple.quarantine ~/Library/QuickLook;
    echo "quicklook: done!";
    echo "";
  else
    echo "quicklook: already installed, skipping...";
    echo "";
  fi
fi

