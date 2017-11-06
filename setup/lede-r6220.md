# LEDE for Netgear R6220

## `make menuconfig`

Select `ramips/mt7621/r6220` and the following additional packages
manually:

- `luci luci-ssl` (`luci-ssl` also selects `libustream-mbedtls` which
  is required to use `https` lists with `adblock`)
- `adblock` or `luci-app-adblock`
- `ca-bundle ca-certificates` (required for `adblock` lists)
- `vnstat` or `luci-app-vnstat`
- `wireguard` or `luci-proto-wireguard`

Consider adding the following:

- `sqm`
