{
  description = "Neovim derivation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # Add bleeding-edge plugins here.
    # They can be updated with `nix flake update` (make sure to commit the generated flake.lock)
    # wf-nvim = {
    #   url = "github:Cassin01/wf.nvim";
    #   flake = false;
    # };
    conform-nvim = {
      url = "github:stevearc/conform.nvim";
      flake = false;
    };

    oil-nvim = {
      url = "github:stevearc/oil.nvim";
      flake = false;
    };

    statuscol-nvim = {
      url = "github:luukvbaal/statuscol.nvim";
      flake = false;
    };

    nvim-ufo = {
      url = "github:kevinhwang91/nvim-ufo";
      flake = false;
    };

    dropbar-nvim = {
      url = "github:Bekaboo/dropbar.nvim";
      flake = false;
    };

    neodev-nvim = {
      url = "github:folke/neodev.nvim";
      flake = false;
    };

    clear-action-nvim = {
      url = "github:luckasRanarison/clear-action.nvim";
      flake = false;
    };

    maximize-nvim = {
      url = "github:declancm/maximize.nvim";
      flake = false;
    };

    ai-nvim = {
      url = "github:gera2ld/ai.nvim";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    ...
  }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    # This is where the Neovim derivation is built.
    neovim-overlay = import ./nix/neovim-overlay.nix {inherit inputs;};
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          # Import the overlay, so that the final Neovim derivation(s) can be accessed via pkgs.<nvim-pkg>
          inputs.neovim-nightly-overlay.overlay
          neovim-overlay
        ];
      };
      shell = pkgs.mkShell {
        name = "nvim-devShell";
        buildInputs = with pkgs; [
          # Tools for Lua and Nix development, useful for editing files in this repo
          lua-language-server
          nil
          stylua
          luajitPackages.luacheck
        ];
      };
    in {
      packages = rec {
        default = nvim;
        nvim = pkgs.nvim-pkg;
      };
      devShells = {
        default = shell;
      };
    })
    // {
      # You can add this overlay to your NixOS configuration
      overlays.default = neovim-overlay;
    };
}
