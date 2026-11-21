# A little bit of boilerplate to add Josh's nvim config to my merge tree
# see https://git.argmin.dk/joshnie/.dotfiles/src/branch/main/home-manager/nvim
{ inputs, ... }: {
  flake.nixosModules.home = {

    # make neovim the default editor, so we never have to suffer with nano
    # Note that I don't disable nano in my config just in case something goes
    # horribly terribly wrong with nvim
    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    home-manager.extraSpecialArgs = { inherit inputs; }; # his files take `inputs` as an argument
    home-manager.users.alexm.imports = [ ./_nvim ];
  };
}
