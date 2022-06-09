# This is to be run directly on new Linux installs
# ex: curl -Lks https://raw.githubusercontent.com/nodssor/public-files/main/boostrap.sh | /bin/bash
#set -x
VERSION=3
echo "Dotfile bootstrapper version: ${VERSION}"

if [ ! -e /usr/bin/git ]; then
  echo "Requires git. [/usr/bin/git] not found."
  echo "Exiting."
  exit 1
fi

timeout 10 /usr/bin/git clone --bare git@github.com:nodssor/.dotfiles.git $HOME/.dotfiles
if [ $? = 124 ]; then
  echo "Git clone timeout. Please make sure you have set up the SSH key correctly."
  echo "Exiting."
  exit 2
fi
dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
$dotfiles checkout > /dev/null 2>&1 
if [ $? = 0 ]; then
  echo "Checked out dot files.";
  else
    echo "Backing up pre-existing dot files.";
    mkdir -p .config-backup
    $dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | cut -d/ -f1 | uniq | xargs -I{} mv {} .config-backup/{}
    $dotfiles checkout > /dev/null 2>&1
    echo "Old files backed up. Checked out current dot files."
fi;

$dotfiles config --local status.showUntrackedFiles no

