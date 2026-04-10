{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    git-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs = { self, nixpkgs, flake-utils, git-hooks }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        pre-commit = git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            # Terraform hooks
            terraform-format = {
              enable = true;
              name = "terraform_fmt";
              entry = "${pkgs.opentofu}/bin/tofu fmt";
            };
            terraform-validate = {
              enable = true;
              name = "terraform_validate";
            };
            terraform-docs = {
              enable = true;
              name = "terraform-docs";
              description = "Generate terraform documentation";
              entry = "${pkgs.terraform-docs}/bin/terraform-docs markdown table --output-file README.md --output-mode inject .";
              files = "\\.tf$";
              pass_filenames = false;
            };
            tflint.enable = true;

            # Security
            gitleaks = {
              enable = true;
              name = "gitleaks";
              entry = "${pkgs.gitleaks}/bin/gitleaks protect --verbose --redact --staged";
              pass_filenames = false;
            };

            # Code quality
            shellcheck.enable = true;
            yamllint.enable = true;
            ruff.enable = true;
            ruff-format.enable = true;
            pylint = {
              enable = true;
              name = "pylint";
              entry = "${pkgs.pylint}/bin/pylint --disable=C";
              types = ["python"];
            };

            # General hooks
            check-merge-conflicts.enable = true;
            check-json.enable = true;
          };
        };
      in
      {
        checks = {
          pre-commit-check = pre-commit;
        };

        devShells.default = pkgs.mkShell {
          inherit (pre-commit) shellHook;
          buildInputs = with pkgs; [
            opentofu
            terraform-docs
            tflint
            gitleaks
            shellcheck
            yamllint
            ruff
            pylint
          ];
        };

        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
