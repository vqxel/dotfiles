# All environment variables, aliases, etc. are handled in my organized dotfiles.
for file in ~/dotfiles/*.dotfile; do
  source "$file"
done
