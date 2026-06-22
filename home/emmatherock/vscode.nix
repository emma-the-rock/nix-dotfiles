{ pkgs, ... }:

let
  marketplace = pkgs.nix-vscode-extensions.vscode-marketplace;
in
{
  home.packages = [
    (pkgs.vscode-with-extensions.override {
      vscodeExtensions = [
        marketplace.openai.chatgpt

        marketplace.ms-python.python
        marketplace.ms-python.vscode-pylance
        marketplace.ms-python.debugpy

        marketplace.jnoortheen.nix-ide
        marketplace.redhat.vscode-yaml
        marketplace.ms-dotnettools.csharp
        marketplace.ms-vscode.cpptools
        marketplace.golang.go
        marketplace.rust-lang.rust-analyzer
        marketplace.ms-azuretools.vscode-containers
        marketplace.ms-vscode-remote.remote-ssh
      ];
    })
  ];
}
