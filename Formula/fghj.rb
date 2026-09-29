class Fghj < Formula
  desc "Local dev environments scoped to a user flow, not your whole fleet"
  homepage "https://github.com/mlnja/fghj"
  version "0.1.5"
  license "MIT"

  # fghj (and its root daemon, fghjd) is macOS-only today: fghjd shells out
  # to macOS's `security` CLI for CA/trust-store management and writes
  # macOS-specific paths (/etc/resolver, Keychain) — no source-build
  # fallback is offered since building from source wouldn't run anywhere
  # else either.
  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/mlnja/fghj/releases/download/v#{version}/fghj-darwin-arm64.tar.gz"
      sha256 "0616e19599e5dfdaaf4da6f834d9bcf3646cde883cab7727c5d482f4acb1aa4c" # darwin-arm64
    end
    on_intel do
      url "https://github.com/mlnja/fghj/releases/download/v#{version}/fghj-darwin-amd64.tar.gz"
      sha256 "5bcd264698c98a35db720ecab16d80230fa91312d4bc7789aa352c0430bf2e5d" # darwin-amd64
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "fghj-darwin-#{arch}" => "fghj"
    bin.install "fghjd-darwin-#{arch}" => "fghjd"
  end

  service do
    # fghjd binds ports 80/443, installs a system-trusted root CA, and edits
    # /etc/resolver and /etc/hosts — all of which require root. Homebrew
    # installs this as a LaunchDaemon (not a per-user LaunchAgent) and it
    # must be started with `sudo brew services start fghj`.
    require_root true
    run [opt_bin/"fghjd"]
    keep_alive true
    log_path var/"log/fghjd.log"
    error_log_path var/"log/fghjd.err.log"
  end

  def caveats
    <<~EOS
      fghjd is a root daemon. It binds ports 80 and 443, answers DNS for
      *.fghj.internal, and installs a local root CA into your system trust
      store — so it is installed as a LaunchDaemon and started with sudo:

        sudo brew services start fghj

      On first start it generates the CA, adds it to the System keychain,
      and writes /etc/resolver/fghj.internal. Both are idempotent. Verify:

        fghj daemon status      # -> fghjd is running and active
        fghj wire .             # register a workspace, prints its UI link

      Requires Docker — Docker Desktop, OrbStack, or Colima. fghjd connects
      to whichever Docker context is active and refuses to start without it.

      `fghj validate` additionally shells out to CUE, if you want it:

        brew install cue

      Logs: #{var}/log/fghjd.log, or the Logs tab at https://fghj.internal/

      `brew upgrade fghj` replaces the binaries but leaves the *running*
      fghjd on the old ones — launchd does not reload on its own, and the
      CLI and daemon must be the same version (they speak a private
      protocol with no compatibility shims). After an upgrade:

        sudo brew services restart fghj

      To release 80/443 and DNS without stopping the process, use
      `fghj daemon stop`; `sudo brew services stop fghj` stops it outright
      and unwinds /etc/resolver and /etc/hosts on the way out.

      Uninstalling does NOT remove the root CA from your System keychain or
      /var/lib/fghjd. To remove those too, before `brew uninstall`:

        sudo security delete-certificate -c "fghj local CA" \\
          /Library/Keychains/System.keychain
        sudo rm -rf /var/lib/fghjd
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fghj --version 2>&1")
  end
end
