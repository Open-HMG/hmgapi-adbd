# Contributing

Thanks for helping. Bugs and ideas for this mod go in
[issues](https://github.com/Open-HMG/hmgapi-adbd/issues); code and docs in pull requests.
Problems with HMG-API itself (the app, the installer, the engine, hook points) go to
[HMG-API's issues](https://github.com/Open-HMG/HMG-API/issues/new/choose).

## Before a pull request

- Build and test off the car with the HMG-API mod SDK, as CI does (the SDK
  `hmgapi-sdk.json` pins; until HMG-API 1.0.3, `./build.sh sdk` in HMG-API at that
  commit). Needs a JDK, Python 3 and the Android SDK (`ANDROID_HOME`); no car files or keys.
- Build: `sh adbd/build.sh out/adbd`, with the Android NDK r21 (`NDK`, default
  `~/Android/ndk/21.4.7075529`). It prints the binary's md5; CI checks it against
  `ADBD_MD5` in `.github/workflows/ci.yml`, so a change to the sources updates that too.
- `third_party/aosp-4.4.4` stays AOSP's code as released; our changes go in
  `third_party/hmgapi-compat` or `adbd/`.
- Say which cars (model, region, software version) a change was tested on, or "off-car only".
- Mod scripts: only commands the head unit has (`$HMGAPI_SDK/bin/check-scripts.sh adbd`).
- A new hook point is a HMG-API pull request first (its catalogue entry, mapped on every
  car); this mod uses it once a HMG-API release has it (HMG-API's `docs/mod-repos.md`,
  section 4).
- Don't change `adbd/mod.json`'s `"version"`: it's set when a release is made.
- Who reviews what (`.github/CODEOWNERS`): VysseCodes reviews CI and releases
  (`.github/`); everything else needs one of the Open-HMG maintainers.

## Rules

- Anything that writes to `/system` keeps a stock checksum check, a backup and an
  uninstall that restores the exact stock bytes.
- The repo holds no manufacturer apps or libraries: only hooks, hash-only recipes,
  delta patch sets, checksums and our own code.
- Never collect or publish per-car secrets (VIN, serials, keys, account tokens,
  `/data` contents), in code, reports, logs or issues.
- Vehicle commands go through the car's own services, never our own CAN frames.
- Commit messages describe the change in plain words.

By contributing you agree your work is licensed under Apache-2.0 for AOSP's code in `third_party/aosp-4.4.4` and AGPL-3.0 for the rest.
