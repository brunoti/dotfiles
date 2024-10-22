brew install protobuf@3
export LDFLAGS="-L$HOME/.config/homebrew/opt/protobuf@3/lib"
export CPPFLAGS="-$HOME/.config/homebrew/opt/protobuf@3/include"
brew link --overwrite protobuf@3
