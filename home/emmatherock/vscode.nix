{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions; [
      jnoortheen.nix-ide
      ms-python.python
      vscode-extensions.ms-dotnettools.csharp
      vscode-extensions.ms-vscode.cpptools
      vscode-extensions.golang.go
      vscode-extensions.rust-lang.rust-analyzer
      vscode-extensions.Google.gemini-cli-vscode-ide-companion
      vscode-extensions.ms-azuretools.vscode-containers
      ms-vscode-remote.remote-ssh
      vscode-extensions.coolbear.systemd-unit-file
      ];
    })
  ];
}
