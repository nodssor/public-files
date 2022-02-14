# This is to be run directly on new Linux installs
# ex: curl -Lks https://raw.githubusercontent.com/nodssor/public-files/main/boostrap.sh
#set -x
/usr/bin/git clone --bare git@github.com:nodssor/.dotfiles.git $HOME/.dotfiles
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

