class Tama < Formula
  desc "Multi-agent AI framework — build, run, and trace agent pipelines from the command line"
  homepage "https://tama.mlops.ninja"
  license "Elastic-2.0"
  version "0.0.5"

  # ── Source tarball — default fallback for unsupported platforms ──────────────
  url "https://github.com/mlnja/tama/archive/refs/tags/v#{version}.tar.gz"
  sha256 "1f746ded27fb589459a854286d208423836aadc035e8676e44eba570c3cdfb28" # source

  # ── Pre-built binaries (override the source url on supported platforms) ──────
  on_macos do
    on_arm do
      url "https://github.com/mlnja/tama/releases/download/v#{version}/tama-darwin-arm64.tar.gz"
      sha256 "47daff202f0623b941850368e3580a840a2be1aa1693688de579a31c0cd81561" # darwin-arm64
    end
    on_intel do
      url "https://github.com/mlnja/tama/releases/download/v#{version}/tama-darwin-amd64.tar.gz"
      sha256 "7993e5318556561c4fc58a7cff9906d24043f2ca2a349c90c90b1b9d9a5a0a98" # darwin-amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mlnja/tama/releases/download/v#{version}/tama-linux-arm64.tar.gz"
      sha256 "6bd1f184d63e95a7854b473e7fe8d6cd348015335ceb38968b226b98d0d9ead5" # linux-arm64
    end
    on_intel do
      url "https://github.com/mlnja/tama/releases/download/v#{version}/tama-linux-amd64.tar.gz"
      sha256 "ab45787b61b853a8500f5e5be02e2b0af1762347f7230ee1adcad118ae7d390a" # linux-amd64
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
