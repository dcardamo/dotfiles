install:
	./bin/install.bash

update:
	./bin/update.bash

update-nixos:
	./bin/update-nixos.bash

update-macos:
	./bin/update-macos.bash

format:
	alejandra .

# Only needs to be run once per app that is new
# backups are automatic once symlinks are done
backup:
	mackup backup

restore:
	mackup restore
