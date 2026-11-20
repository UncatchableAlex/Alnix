# A little bit of boilerplate to add Josh's nvim config to my merge tree
# see https://git.argmin.dk/joshnie/.dotfiles/src/branch/main/home-manager/nvim
{ inputs, ... }: {
  flake.nixosModules.home = {
    home-manager.extraSpecialArgs = { inherit inputs; };  # his files take `inputs` as an argument
    home-manager.users.alexm.imports = [ ./_nvim ];
  };
}
