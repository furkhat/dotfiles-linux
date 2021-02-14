with import <nixpkgs> {};

vim_configurable.customize {
  name = "vim"; # Specifies the vim binary name.
  vimrcConfig.customRC = builtins.readFile ./vimrc;
  vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
    start = [
      vim-go
    ];
  };
}
