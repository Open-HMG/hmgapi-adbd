# hmgapi-adbd

**adbd with key checks**, a mod for [HMG-API](https://github.com/Open-HMG/HMG-API) on
Hyundai, Kia and Genesis Gen5W head units. **Not released and not in HMG-API's
catalogue yet**: for testing only.

The head unit's own adbd lets any computer in: it never checks keys. This mod runs
Android 4.4's own adbd (AOSP 4.4.4) in its place. A new computer gets Android's "Allow
USB debugging?" prompt on the screen, and only computers you allow get adb, over USB
and Wi-Fi.

It's swapped in while running: a bind mount of `files/hmgapi-adbd` over `/sbin/adbd`
and an adbd restart (`patches.json`), so nothing on the read-only root changes. Turning
the mod off, or any restart without it, brings the stock adbd back.

## Cars

Gen5W head units on Telechips TCC803x with Android 4.4.2 (`mod.json` `"system"`), with
HMG-API 1.0.0 or newer.

## Building

```
adbd/              the mod: mod.json, patches.json; build.sh builds files/hmgapi-adbd
third_party/       aosp-4.4.4: AOSP 4.4.4's adbd, libcutils, libmincrypt (Apache-2.0, unmodified)
                   hmgapi-compat: a stand-in header for what the build leaves out
hmgapi-sdk.json    the HMG-API mod SDK it packages with (a HMG-API commit until 1.0.3)
.github/workflows  ci.yml, release.yml
```

`adbd/build.sh` needs the Android NDK r21 (`sdkmanager "ndk;21.4.7075529"`; set `NDK` if
it isn't in `~/Android/ndk/21.4.7075529`). It builds for API 19 against the head unit's
own libc, liblog and libdl, and prints the binary's md5:

```
sh adbd/build.sh out/adbd
```

The binary is the same as HMG-API's build before the move: `e480b55bd0ffded055a0cf362623e975`
with `LC_ALL=C` (what CI checks), `f61ff1fd0b98e1f4289639be7a8a0c68` in an `en_US.UTF-8`
shell. The locale sorts the `*.c` globs, which sets the link order. With the HMG-API mod SDK unpacked in `$HMGAPI_SDK`, the package
(`build.sh` runs inside it):

```
$HMGAPI_SDK/bin/mkmodpkg.sh adbd <key>
```

## Releases

None yet. When it's time, a tag `v<version>` matching `adbd/mod.json`'s `"version"`
runs `release.yml`, which makes a **draft** release signed with the author key (the
`release` environment's `MOD_KEY`).

## Licence

AOSP's code in `third_party/aosp-4.4.4`: Apache-2.0 (its [NOTICE](third_party/aosp-4.4.4/NOTICE)).
HMG-API's parts (`adbd/`, `third_party/hmgapi-compat`, the workflows): AGPL-3.0
([LICENSE](LICENSE)).
