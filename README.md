# JRuby9K_POC

Proof of concept for using JRuby 9K in a Ruboto project

This repository contains a sample Android Studio project using JRuby.

## Emulator/phone Android version

The app currently works with emulators/devices running Android 8.1 (api 27) to Andorid 12L (api 32).

| Android 13.0 |  | 33 | no  |
| Android 12L  |  | 32 | yes |
| Android 12.0 |  | 31 | yes |
| Android 11.0 |  | 30 | yes |
| Android 10.0 |  | 29 | yes |
| Android  9.0 |  | 28 | yes |
| Android  8.1 |  | 27 | yes |

Android 13.0 (api 33) is failing with new security restrictions.

## Adding JRuby to an AndroidStudio project

Use the `update_jruby_jar.sh` script in the `app` folder:

```bash
cd app
./update_jruby_jar.sh
```

## Adding gems

* Add your Gemfile in the `app` directory.
* Run the `bundle` Rake task using JRuby

```bash
jruby -S rake bundle
```
