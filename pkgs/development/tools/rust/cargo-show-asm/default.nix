{ lib
, rustPlatform
, fetchCrate
, installShellFiles
, stdenv
, nix-update-script
, callPackage
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-show-asm";
  version = "0.2.19";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-bIaEXlMIEQ2pnzjp7ll6iJFGAQjGb3HVBTbfGSPHrvg=";
  };

  cargoHash = "sha256-qmxd6qt8pL/5TWPDCiBQrvqb6r7VAJOrSR1OSpibQFU=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd cargo-asm \
      --bash <($out/bin/cargo-asm --bpaf-complete-style-bash) \
      --fish <($out/bin/cargo-asm --bpaf-complete-style-fish) \
      --zsh  <($out/bin/cargo-asm --bpaf-complete-style-zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = lib.optionalAttrs stdenv.hostPlatform.isx86_64 {
      test-basic-x86_64 = callPackage ./test-basic-x86_64.nix { };
    };
  };

  meta = with lib; {
    description = "Cargo subcommand showing the assembly, LLVM-IR and MIR generated for Rust code";
    homepage = "https://github.com/pacak/cargo-show-asm";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda oxalica ];
    mainProgram = "cargo-asm";
  };
}
