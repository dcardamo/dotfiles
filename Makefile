install-darwin:
	./bin/install-darwin.bash

backup:
	./bin/backup-dotfiles.sh

update:
	./bin/update.sh

update-system:
	./bin/update-system.sh

update-all: backup update-system update

format:
	alejandra .

# Identify dead code in nix files
deadnix:
	nix run github:astro/deadnix
