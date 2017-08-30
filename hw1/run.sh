# run.sh

# TAs: I use a simple library for Ruby that makes a command line interface really easy to write
# called Thor. The first line of this script installs that library in your home directory. Just
# in case you were worried about something fishy happening, that's all this first command does.

gem install --user-install thor &> /dev/null && ruby solution.rb test