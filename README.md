# sprite-profile-apiary

A [sprite-profiles](https://github.com/antialias/sprite-profiles) profile that routes Claude
Code in a [Fly.io Sprite](https://sprites.dev) through [Apiary](https://apiary.wtf)'s switch
proxy, the same way Apiary's client does on a laptop. Claude Code's requests to Anthropic go
through `switch.apiary.wtf`, which serves them from your Apiary's accounts and model classes.
No Anthropic key and no claude.ai sign-in are in the Sprite.

## Use it

```sh
sprite-profiles show @antialias/apiary
sprite-profiles launch claude-code @antialias/apiary --name my-sprite
```

During the launch the Sprite enrols as an Apiary device named `sprite-<name>`. The launch
prints a code; approve it at [apiary.wtf/devices](https://apiary.wtf/devices) within ten
minutes. Then `claude` in the Sprite runs through the proxy.

## What it costs

- **A device token lives in the Sprite.** It lasts 24 hours and renews itself, in
  `~/.apiary` (mode 0600; never printed). The profile sets `checkpoint = false`, so it is
  applied after the launch's checkpoint and the token is never saved in one. Revoke the
  device at apiary.wtf/devices to cut the Sprite off.
- **Each new Sprite is approved by a person**, once.
- **Claude Code's own requests leave through the proxy**, so the Sprite's network rules don't
  cover them (its Bash tool's commands don't use the proxy). Apiary's certificate is limited
  to `api.anthropic.com`; anything else passes through the proxy unopened.
- **Fly's connector gateway stays direct** (`api.sprites.dev` is in the client's no-proxy
  list), so other profiles' connectors, such as
  [`@antialias/shop-inventory`](https://github.com/antialias/sprite-profile-shop-inventory),
  still see the Sprite.

Why not a Fly connector: a custom API connector holds one fixed token in front of a base
URL. Apiary is an HTTPS proxy whose device tokens renew every day, so the Sprite holds the
device's token instead. Don't combine this profile with `anthropic` or `anthropic-key`.

## What is in it

- `profile.toml`: the network rules (`apiary.wtf`, `switch.apiary.wtf`), `checkpoint = false`
  and a 12-minute setup window.
- `setup.sh`: installs the Apiary client, runs `apiary setup`, keeps the gateway direct,
  enrols the Sprite, and runs `apiary doctor`, printing its report only when it fails.

Versions are tags: `v1.0.0` is what `@antialias/apiary@1` picks.

## License

Apache-2.0. See [LICENSE](LICENSE).
