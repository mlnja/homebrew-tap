class Llmfmt < Formula
  desc "Deterministic CLI for converting structured data into compact, prompt-ready text for LLM workflows"
  homepage "https://github.com/mlnja/llmfmt"
  license "MIT"
  version "0.1.1"

  # ── Source tarball — default fallback for unsupported platforms ──────────────
  url "https://github.com/mlnja/llmfmt/archive/refs/tags/v#{version}.tar.gz"
  sha256 "6db8b9a4c9b384e83e726361ed0eb58f173d0f4e3d4158cccb1bc8d951a94eb8" # source

  # ── Pre-built binaries (override the source url on supported platforms) ──────
  on_macos do
    on_arm do
      url "https://github.com/mlnja/llmfmt/releases/download/v#{version}/llmfmt-darwin-arm64.tar.gz"
      sha256 "5c3a9b3de96f45d9cdc2b9945d470e14e17fa67057d6f0e99d8019feb310ba85" # darwin-arm64
    end
    on_intel do
      url "https://github.com/mlnja/llmfmt/releases/download/v#{version}/llmfmt-darwin-amd64.tar.gz"
      sha256 "e64434aaf4a94c6c2725ebd1bda74d9d356a7b8ddd5dac8c48f72bba6ab4c86d" # darwin-amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mlnja/llmfmt/releases/download/v#{version}/llmfmt-linux-arm64.tar.gz"
      sha256 "9202b424a0d88d59d2512643e0ef7897b612a831279dd8d7e8fabe2693a114b4" # linux-arm64
    end
    on_intel do
      url "https://github.com/mlnja/llmfmt/releases/download/v#{version}/llmfmt-linux-amd64.tar.gz"
      sha256 "b2f0b6f80e5b2de94bcb7b3e1bb235d216b5d3fed5964fbfd5309b3278fd322e" # linux-amd64
    end
  end

  def install
    binary = Dir["llmfmt-*"].find { |f| File.file?(f) && !f.end_with?(".tar.gz", ".sha256") }

    if binary
      bin.install binary => "llmfmt"
    else
      odie "No pre-built binary for this platform. Install Rust (https://rustup.rs) then rerun with --build-from-source"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfmt --version 2>&1")
  end
end
