{ pkgs, inputs, ... }:

let
  agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = with agents; [
    antigravity-cli
    codex
    claude-code
  ];
}