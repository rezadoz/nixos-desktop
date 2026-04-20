{ config, pkgs, ... }:

{
  imports = [
    ./shell.nix
  ];

  home.username = "bread";
  home.homeDirectory = "/home/bread";
  home.stateVersion = "24.11";

  home.sessionVariables = {
    EDITOR  = "nvim";
    VISUAL  = "nvim";
    PAGER   = "less";
    MANPAGER = "nvim +Man!";
  };

  home.packages = with pkgs; [
    bat
    fd
    fzf
    jq
    ripgrep
    tree
    zsh-powerlevel10k
  ];

  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      user.name  = "rezadoz";
      user.email = "rezadoz@gmail.com";
      init.defaultBranch = "master";
      pull.rebase = true;
      core.editor = "nvim";
      diff.tool = "nvimdiff";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias  = true;
    vimAlias = true;
    withRuby   = false;
    withPython3 = false;
  };

  programs.home-manager.enable = true;
}
