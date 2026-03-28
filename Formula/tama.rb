class Tama < Formula
  desc "Multi-agent AI framework — build, run, and trace agent pipelines from the command line"
  homepage "https://tama.mlops.ninja"
  license "Elastic-2.0"
  version "0.0.4"

  # ── Source tarball — default fallback for unsupported platforms ──────────────
  url "https://github.com/mlnja/tama/archive/refs/tags/v#{version}.tar.gz"
  sha256 "a75b46417687b82e6bc3e21e9dc383d3e9da2c23dd8b8202b9674a61fd6c9e43" # source

  # ── Pre-built binaries (override the source url on supported platforms) ──────
  on_macos do
    on_arm do
      url "https://github.com/mlnja/tama/releases/download/v#{version}/tama-darwin-arm64.tar.gz"
      sha256 "dba4e0f999e727000d49cfcaf94c7860f25b8b15017afb3e4900e6ae2b5da40a" # darwin-arm64
    end
    on_intel do
      url "https://github.com/mlnja/tama/releases/download/v#{version}/tama-darwin-amd64.tar.gz"
      sha256 "d2252e083f23039ccc1f38ae25c197b09242295980914bcc3bb513d1b7eb26f1" # darwin-amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mlnja/tama/releases/download/v#{version}/tama-linux-arm64.tar.gz"
      sha256 "24a6991198bbfb79020564daee98020fe79e749eb54e827645065578017b38ff" # linux-arm64
    end
    on_intel do
      url "https://github.com/mlnja/tama/releases/download/v#{version}/tama-linux-amd64.tar.gz"
      sha256 "deb40960c5d42efe78d93a9acbed78579d58b351e6ec6e67101e33dc594dc57d" # linux-amd64
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
