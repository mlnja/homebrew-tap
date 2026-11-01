class Fghj < Formula
  desc "Local dev environments scoped to a user flow, not your whole fleet"
  homepage "https://github.com/mlnja/fghj"
  version "0.2.2"
  license "MIT"

  # macOS only: Linux installs from apt.mlops.ninja instead. No source-build
  # fallback; the release binaries are the only supported build.
  depends_on :macos
  # Apple Silicon only: there is no darwin-amd64 build.
  depends_on arch: :arm64

  on_macos do
    on_arm do
      url "https://github.com/mlnja/fghj/releases/download/v#{version}/fghj-darwin-arm64.tar.gz"
      sha256 "b02caaab9d7e6d2859474d27f024b9da77366031c46a31865541c21d72d819a9" # darwin-arm64
    end
  end

  def install
    bin.install "fghj-darwin-arm64" => "fghj"
    bin.install "fghjd-darwin-arm64" => "fghjd"
  end

  service do
    # fghjd binds ports 80/443, keeps its CA's private key under
    # /var/lib/fghjd, and edits /etc/resolver and /etc/hosts — all of which
    # require root. Homebrew installs this as a LaunchDaemon (not a per-user
    # LaunchAgent) and it must be started with `sudo brew services start fghj`.
    require_root true
    run [opt_bin/"fghjd"]
    keep_alive true
    log_path var/"log/fghjd.log"
    error_log_path var/"log/fghjd.err.log"
  end

  def caveats
    <<~EOS
      fghjd is a root daemon. It binds ports 80 and 443 on its own loopback
      address (127.222.0.1), answers DNS for *.fghj.internal, and edits
      /etc/resolver and /etc/hosts — so it is installed as a LaunchDaemon
      and started with sudo:

        sudo brew services start fghj

      On first start it generates a local root CA and writes
      /etc/resolver/fghj.internal. Two things it can't do as a daemon, and
      your first `fghj wire` does instead, from your terminal, as you:

        - pick your Docker (Docker Desktop, OrbStack or Colima): the one
          your `docker` command uses
        - trust the CA in your login keychain: macOS shows a password
          dialog once; no sudo

      Then:

        fghj daemon status      # -> fghjd is running and active
        fghj doctor             # Docker and CA show as pending until your first wire
        fghj wire .             # register a workspace, prints its UI link

      If the CA ever isn't trusted, `fghj doctor --fix` asks again.

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

      `brew uninstall` can't remove the trusted CA or /var/lib/fghjd (which
      holds its private key). To remove everything:

        sudo fghj uninstall
        brew uninstall fghj

      It lists what it will remove and asks first. Your Docker containers,
      networks and volumes are left alone. Full list:
      https://fghj.mlops.ninja/guides/uninstalling/
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fghj --version 2>&1")
  end
end
