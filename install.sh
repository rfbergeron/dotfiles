#!/bin/sh

set -o nounset
set -o errexit

# cd into the bundle and use relative paths
cd "$(dirname "$0")" || {
	echo 'Unable to cd into bundle directory; exiting.'
	exit 1
}
[ -n "$HOME" ] || {
	echo "\$HOME is unset; exiting."
	exit 1
}
[ -w "$HOME" ] || {
	echo "\$HOME is not writeable; exiting."
	exit 1
}

cp ./profile "$HOME"/.profile
cp ./shrc "$HOME"/.shrc

if command -v bash >/dev/null 2>&1; then
	cp ./bashrc "$HOME"/.bashrc
	cp ./bash_profile "$HOME"/.bash_profile
	#cp ./bash_logout "$HOME"/.bash_logout
fi

config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}
state_dir=${XDG_STATE_HOME:-$HOME/.local/state}

if [ -z "${REMOVE_CLUTTER+x}" ]; then
	cp ./inputrc "$HOME"/.inputrc
	if command -v tmux >/dev/null 2>&1; then
		cp ./tmux.conf "$HOME"/.tmux.conf
	fi
	mkdir -p "$HOME"/.bin
else
	mkdir -p "$HOME"/.local/bin
	mkdir -p "$config_dir"/readline
	cp ./inputrc "$config_dir"/readline/
	if command -v tmux >/dev/null 2>&1; then
		mkdir -p "$config_dir"/tmux
		cp ./tmux.conf "$config_dir"/tmux/
	fi
	if command -v npm >/dev/null 2>&1; then
		mkdir -p "$config_dir"/npm
		cp ./npmrc "$config_dir"/npm
	fi
	if command -v python >/dev/null 2>&1; then
		mkdir -p "$config_dir"/python
		cp ./startup.py "$config_dir"/python
	fi
	if command -v yarn >/dev/null 2>&1; then
		mkdir -p "$config_dir"/yarn
		# yarn needs a file to be here, even if it is empty
		touch "$config_dir"/yarn/config
		printf '#!/bin/sh\nexec yarn --use-yarnrc "$XDG_CONFIG_HOME"/yarn/config "$@"' >"$HOME"/.local/bin/yarn
	fi
	if command -v mvn >/dev/null 2>&1; then
		mkdir -p "$config_dir"/maven
		cp ./maven/settings.xml "$config_dir"/maven/
		printf '#!/bin/sh\nexec mvn -gs "$XDG_CONFIG_HOME"/maven/settings.xml "$@"' >"$HOME"/.local/bin/mvn
	fi
	if command -v sloccount >/dev/null 2>&1; then
		printf '#!/bin/sh\nexec sloccount --datadir "$XDG_CACHE_HOME"/sloccount "$@"' >"$HOME"/.local/bin/sloccount
	fi
fi

if [ -d "$HOME"/.local ]; then
	mkdir -p "$HOME"/.local/bin
else
	mkdir -p "$HOME"/.bin
fi

if command -v nvim >/dev/null 2>&1; then
	mkdir -p "$config_dir"/nvim
	cp ./nvim/init.lua "$config_dir"/nvim/
	nvim_packs="$data_dir"/nvim/site/pack
	mkdir -p "$nvim_packs"
	# make directories for undo, swap, and backup files
	mkdir -p "$state_dir"/nvim/undo "$state_dir"/nvim/backup "$state_dir"/nvim/swap
	# set permissions separately in case the directories already existed
	chmod 0700 "$state_dir"/nvim/undo "$state_dir"/nvim/backup "$state_dir"/nvim/swap
	# make package directories
	treesitter_dir="$nvim_packs/treesitter/start"
	plugin_dir="$nvim_packs/plugins/start"
	lsp_dir="$nvim_packs/lsp/start"
	mkdir -p "$treesitter_dir" "$plugin_dir" "$lsp_dir"

	# install packages
	while read -r arguments; do
		install_path=$(echo "$arguments" | cut -d' ' -f1)
		repo_url=$(echo "$arguments" | cut -d' ' -f2)
		clone_dir=$(echo "$arguments" | cut -d' ' -f3)
		branch="$(echo "$arguments" | cut -d' ' -f4)"
		full_path="$install_path/$clone_dir"

		if [ -d "$full_path" ]; then
			git -C "$full_path" status
		elif [ -n "$branch" ]; then
			git clone --branch="$branch" "$repo_url" "$full_path"
		else
			git clone "$repo_url" "$full_path"
		fi
	done <<-EOF
		$lsp_dir htts://github.com/hrsh7th/cm-nvim-lsp.git cmp-lsp
		$lsp_dir https://github.com/saadparwaiz1/cmp_luasnip.git cmp-luasnip
		$lsp_dir https://github.com/VonHeikemen/lsp-zero.nvim.git lsp-zero
		$lsp_dir https://github.com/L3MON4D3/LuaSnip.git luasnip
		$lsp_dir https://github.com/Bilal2453/luvit-meta.git luvit-meta
		$lsp_dir https://github.com/hrsh7th/nvim-cmp.git cmp
		$lsp_dir https://github.com/neovim/nvim-lspconfig.git lspconfig v2.3.0
		$lsp_dir https://github.com/b0o/SchemaStore.nvim.git schemastore
		$plugin_dir https://github.com/lukas-reineke/indent-blankline.nvim.git indent-blankline v3.9.0
		$plugin_dir https://github.com/echasnovski/mini.nvim.git mini v0.16.0
		$plugin_dir https://github.com/mbbill/undotree.git undotree rel_6.1
		$treesitter_dir https://github.com/nvim-treesitter/nvim-treesitter.git treesitter main
		$treesitter_dir https://github.com/nvim-treesitter/nvim-treesitter-textobjects.git treesitter-textobjects main
	EOF
else
	echo "Unable to locate neovim executable; skipping package installation."
fi
