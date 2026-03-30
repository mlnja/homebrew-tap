class Tama < Formula
  desc "Multi-agent AI framework — build, run, and trace agent pipelines from the command line"
  homepage "https://tama.mlops.ninja"
  license "Elastic-2.0"
  version "0.0.7"

  # ── Source tarball — default fallback for unsupported platforms ──────────────
  url "https://github.com/mlnja/tama/archive/refs/tags/v#{version}.tar.gz"
  sha256 "82e82cc4a7c1250d87b5b0b6ee89a266c912e8889076a4b525e82f7430ce4fb2" # source

  # ── Pre-built binaries (override the source url on supported platforms) ──────
  on_macos do
    on_arm do
      url "https://github.com/mlnja/tama/releases/download/v#{version}/tama-darwin-arm64.tar.gz"
      sha256 "d0a0a04a428552a26422d526ea061804be34c267b49263f342ed34d17c65b13b" # darwin-arm64
    end
    on_intel do
      url "https://github.com/mlnja/tama/releases/download/v#{version}/tama-darwin-amd64.tar.gz"
      sha256 "a87ad638b322091a36436612a283ed873521d49397036714a46a28e2a6266b2d" # darwin-amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mlnja/tama/releases/download/v#{version}/tama-linux-arm64.tar.gz"
      sha256 "7010a10a3fb031c296e1f9c0c0ba29d7930013a0bfec386279409766eee0f8c4" # linux-arm64
    end
    on_intel do
      url "https://github.com/mlnja/tama/releases/download/v#{version}/tama-linux-amd64.tar.gz"
      sha256 "88f970a569e0c004e7f88e0e7b16a191d3f86045411e9762d8eedb9b98fe611e" # linux-amd64
    end
  end

  def install
    # Pre-built binary: a plain file named tama-<os>-<arch> (from the release tarball)
    binary = Dir["tama-*"].find { |f| File.file?(f) && !f.end_with?(".tar.gz", ".sha256") }

    if binary
      bin.install binary => "tama"
    else
      odie "No pre-built binary for this platform. Install Rust (https://rustup.rs) then rerun with --build-from-source"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tama --version 2>&1")
  end
end
