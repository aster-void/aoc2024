{
  description = "Advent of Code (solver) 2024";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    rules-mojo.url = "github:TraceMachina/rules_mojo";
    rules-mojo.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, utils, rules-mojo, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        packages = {
          dev = with pkgs; [ just ];

          go = with pkgs; [ go ];
          rust = with pkgs; [ rustc cargo rust-analyzer ];
          c = with pkgs; [ gcc ];
          cpp = with pkgs; [ clang-tools clang ]; # clang-tools must come first
          zig = with pkgs; [ zig zls ];
          haskell = with pkgs; [ stack haskell-language-server ormolu ];
          gleam = with pkgs; [ gleam erlang_27 ];
          elixir = with pkgs; [ elixir elixir-ls ];
          clojure = with pkgs; [ clojure clojure-lsp ];
          ocaml = with pkgs; [ dune_3 ocaml ocamlPackages.ocaml-lsp ];
          fsharp = with pkgs; [ dotnet-sdk fsharp ];
          csharp = with pkgs; [ dotnet-sdk csharp-ls ];
          java = with pkgs; [ jdk23_headless ];
          scala = with pkgs; [ scala-cli sbt metals ];
          kotlin = with pkgs; [ kotlin kotlin-language-server ];
          swift = with pkgs; [ swift sourcekit-lsp swiftlint swiftformat ];
          dart = with pkgs; [ dart ];
          javascript = with pkgs; [ bun ];
          python = with pkgs; [ python312 python312Packages.python-lsp-server black ruff ];
          nim = with pkgs; [ nim nimble nimlangserver ];
          lobster = with pkgs; [ lobster ];
          lua = with pkgs; [ lua lua-language-server ];
          ruby = with pkgs; [ ruby ruby-lsp ];
          php = with pkgs; [ php phpactor ];
          julia = with pkgs; [ julia ]; # Apparently julia lsp is not published on nixpkgs
          R = with pkgs; [ R ];
          mojo = [ rules-mojo.packages.${system}.mojo ]; # Mojo is a very new language and there is no support for nix by nixpkgs team yet.
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with packages; [
            dev
            zig
            c
            go
            cpp
            rust
            haskell
            gleam
            elixir
            ocaml
            fsharp
            csharp
            java
            scala
            kotlin
            # swift
            dart
            javascript
            python
            nim
            lobster
            ruby
            php
            julia
            R
            mojo
          ];
          shellHook = ''
            export LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib
          '';
        };
      });
}
