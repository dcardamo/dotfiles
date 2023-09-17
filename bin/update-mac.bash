GREEN='\033[1;32m'
#RED='\033[1;31m'
CLEAR='\033[0m'

echo "${GREEN}Updating brew casks and app store apps...${CLEAR}"
/opt/homebrew/bin/brew analytics off
/opt/homebrew/bin/brew update
/opt/homebrew/bin/brew bundle --force cleanup
/opt/homebrew/bin/mas upgrade
echo "${GREEN}Done${CLEAR}"
