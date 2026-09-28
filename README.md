# MLnja Tap

## fghj

Local dev environments scoped to a user flow, not your whole fleet.

```bash
brew install mlnja/tap/fghj
sudo brew services start fghj
```

`fghjd` is a root LaunchDaemon (it binds 80/443, answers DNS for
`*.fghj.internal`, and installs a local CA), hence the `sudo` on the second
command. macOS only.

## tama

Multi-agent AI framework — build, run, and trace agent pipelines from the command line.

```bash
brew install mlnja/tap/tama
```

Or explicitly tap first:

```bash
brew tap mlnja/tap
brew install tama
```

Or in a `Brewfile`:

```ruby
tap "mlnja/tap"
brew "tama"
```

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
