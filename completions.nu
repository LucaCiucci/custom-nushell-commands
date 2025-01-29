

# Completions
export use nu_scripts/custom-completions/bat/bat-completions.nu *
export use nu_scripts/custom-completions/cargo/cargo-completions.nu *
export use nu_scripts/custom-completions/docker/docker-completions.nu *
export use nu_scripts/custom-completions/git/git-completions.nu *
export use nu_scripts/custom-completions/just/just-completions.nu *
export use nu_scripts/custom-completions/make/make-completions.nu *
export use nu_scripts/custom-completions/man/man-completions.nu *
export use nu_scripts/custom-completions/nano/nano-completions.nu *
export use nu_scripts/custom-completions/nix/nix-completions.nu *
export use nu_scripts/custom-completions/npm/npm-completions.nu *
export use nu_scripts/custom-completions/pnpm/pnpm-completions.nu *
export use nu_scripts/custom-completions/rustup/rustup-completions.nu *
export use nu_scripts/custom-completions/ssh/ssh-completions.nu *
export use nu_scripts/custom-completions/tar/tar-completions.nu *
export use nu_scripts/custom-completions/typst/typst-completions.nu *
export use nu_scripts/custom-completions/vscode/vscode-completions.nu *

# Alias for `git pull --rebase`
export extern "git up" []
#{ ^git pull --rebase }

