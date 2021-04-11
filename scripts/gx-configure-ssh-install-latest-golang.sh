# Update and get xclip
# Installing latest GO
set -euf -o pipefail

# Install pre-reqs
sudo apt-get install python3 git -y
o=$(python3 -c $'import os\nprint(os.get_blocking(0))\nos.set_blocking(0, True)')

#Download Latest Go
GOURLREGEX='https://dl.google.com/go/go[0-9\.]+\.linux-amd64.tar.gz'
echo "Finding latest version of Go for AMD64..."
latest="$(curl 'https://golang.org/VERSION?m=text')"
url="https://dl.google.com/go/$latest.linux-amd64.tar.gz"
echo "Downloading latest Go for AMD64: $url"
wget --quiet --continue --show-progress $url
unset url
unset GOURLREGEX

# Remove Old Go
sudo rm -rf /usr/local/go

# Install new Go
sudo tar -C /usr/local -xzf "${latest}".linux-amd64.tar.gz
echo "Create the skeleton for your local users go directory"
mkdir -p ~/go/{bin,pkg,src}
echo "Setting up GOPATH"
echo "export GOPATH=~/go" >> ~/.profile && source ~/.profile
echo "Setting PATH to include golang binaries"
echo "export PATH='$PATH':/usr/local/go/bin:$GOPATH/bin" >> ~/.profile && source ~/.profile
echo "Setting GOPRIVATE to work with GOMODS"
echo "export GOPRIVATE='bitbucket.org/eucatur,bitbucket.org/eumais,github.com/eucatur'" >> ~/.profile && source ~/.profile

# Remove Download
rm "${latest}".linux-amd64.tar.gz

# Print Go Version
/usr/local/go/bin/go version
python3 -c $'import os\nos.set_blocking(0, '$o')'

# Configure SSH
echo "Making go get use ssh instead of https"
git config --global url.git@github.com:.insteadOf https://github.com/
git config --global url.git@bitbucket.org:.insteadOf https://bitbucket.org/
echo "SSH intead of HTTPS: Done"
clear

echo "Generating SSH key"
ssh-keygen -t rsa -b 4096 -C $git_config_user_email
ssh-add ~/.ssh/id_rsa
echo "SSS key generated"

xclip -sel clip < ~/.ssh/id_rsa.pub
echo "SSH Key is in clipboard, now you can add at github, bitbucket e etc..."
echo "After that test the connections with: ssh -T git@github.com ssh -T git@bitbucket.org"

# Made by http://github.com/gleyconxavier
