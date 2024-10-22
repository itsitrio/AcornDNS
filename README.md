# Itrio's DNS

```
It’s not DNS
There’s no way it’s DNS
It was DNS
```

Zones for Itrio's infrastructure

## Making Changes

All dns entries can be found in `zones/<domain>.yaml`.
Records are configured using [octodns yaml files](https://github.com/octodns/octodns/blob/main/docs/records.md).
When you're ready, create a branch for your changes and open a pull request.
Github Actions will automatically perform a dry run of your changes and comment with the result.
If everything looks good, merge the PR and your changes should be automatically deployed.

Please avoid pushing directly to `main` unless you know what you're doing.

## Excluded Records

Both Letsencrypt and Cloudflare automatically creates some DNS entries for us that we don't want to manage.
Check out `processors` in `dns.yaml` for more info.

## Running Locally

All dependencies are pulled in using [nix](https://nixos.org/),
once you have it set up run `nix develop` to get a shell with octodns available.
Alternatively if you don't like nix just install `octodns` and `octodns-cloudflare` using `pip`.
You'll also need to set an environment variable `CLOUDFLARE_API_TOKEN` with your cloudflare api key.

Common commands:

- See Changes: `octodns-sync --config-file=dns.yaml`
- Apply Changes: `octodns-sync --config-file=dns.yaml --doit`

### Nix Install Guide

This guide assumes Arch linux but should work on most *nix OSes

```bash
pacman -S nix
mkdir -p ~/.config/nix/
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
sudo systemctl enable nix-daemon
sudo systemctl start nix-daemon
sudo usermod -aG nix-users $USER
```

Log back in to let your groups update
