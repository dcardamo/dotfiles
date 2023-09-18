install:
	./bin/install.bash

update-nix:
	./bin/update.bash

update-mac:
	./bin/update-mac.bash

update: update-nix update-mac

format:
	alejandra .

# Only needs to be run once per app that is new
# backups are automatic once symlinks are done
backup:
	mackup backup

restore:
	mackup restore
