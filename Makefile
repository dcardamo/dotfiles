install-darwin:
	./bin/install-darwin.bash

update:
	./bin/update.sh

update-system:
	./bin/update-system.sh

update-all: update-system update

format:
	alejandra .

# Identify dead code in nix files
deadnix:
	nix run github:astro/deadnix
