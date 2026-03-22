{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Gleam
            gleam
            erlang
            rebar3

            nodejs-slim
            bun
            inotify-tools

            just
            just-formatter
            just-lsp
          ];

          shellHook = ''
            mkdir -p .erlang
            export MIX_HOME=$PWD/.erlang/mix
            export HEX_HOME=$PWD/.erlang/hex
            export ERL_LIBS=$HEX_HOME/lib/erlang/lib

            export PATH=$MIX_HOME/bin:$PATH
            export PATH=$MIX_HOME/escripts:$PATH
            export PATH=$HEX_HOME/bin:$PATH

            export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_path '\"$PWD/.erlang/history\"'"
          '';
        };
      }
    );
}
