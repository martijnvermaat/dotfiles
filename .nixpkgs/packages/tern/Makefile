node-packages.nix: node-packages.json
	nix-shell -p npm2nix --run npm2nix --nodev $< $@
