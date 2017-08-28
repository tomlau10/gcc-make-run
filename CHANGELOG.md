# Changelog

## 0.2.12
* Fix not handling `TextBuffer.save()` becoming async in atom 1.19 correctly [[\#19](https://github.com/tomlau10/gcc-make-run/issues/19)@maxbrunsfeld] [[\#28](https://github.com/tomlau10/gcc-make-run/issues/28)@ziadxkabakibi]
* Fix `setText() of undefined` in run option view  [[\#27](https://github.com/tomlau10/gcc-make-run/issues/29)@kebien6020]

## 0.2.11
* Fix `terminal start command` config `#{title}` causing config.cson error and changed to `$title` [[\#23](https://github.com/tomlau10/gcc-make-run/issues/23)@aquaraider11]
* If encountered this issue already, needs manually delete the `terminal` key under `gcc-make-run` in `config.cson` (`File` > `Config...`)

## 0.2.10
* Fix extra windows due to not handling deactivate correctly [[\#12](https://github.com/tomlau10/gcc-make-run/issues/12)@Dreded]
* Fix cannot change focus in options view
* Add `terminal start command` config for Linux platform [[\#22](https://github.com/tomlau10/gcc-make-run/pull/22)@aquaraider11]

## 0.2.9
* Add `Press any key to continue` after running in MacOS platform [[\#9](https://github.com/tomlau10/gcc-make-run/pull/9)@crazymousethief]

## 0.2.8
* Fix run options not working after previous update [[\#6](https://github.com/tomlau10/gcc-make-run/issues/6)@Weslysilva]

## 0.2.7
* Add output extension setting [[\#5](https://github.com/tomlau10/gcc-make-run/issues/5)@adiultra]
* Fix input cursor going to background when clicking the option view

## 0.2.6
* Add `Press Enter to continue` after running in Linux platform [[\#3](https://github.com/tomlau10/gcc-make-run/issues/3)@nilosweden]

## 0.2.1 - 0.2.5
* Fix images links in readme
* Fix a rendering problem in readme
* Fix detection for `C++14` grammar [[\#1](https://github.com/tomlau10/gcc-make-run/issues/1)@Adobe-Android]
* Fix typo in readme

## 0.2.0
* Improve option panel UI and CSS
* Update readme and images
* Fix wrong shortcut binding in Mac
* Add a `debug` flag in config

## 0.1.1
* Fix setting page not show up due to [*wrong use*](https://discuss.atom.io/t/configuration-vars-dont-show-up/14480) of `activationCommand` in `package.json`

## 0.1.0 - First Release
* Add Compile-Run and Make-Run function **(remake of [kriscross07/gpp-compiler](https://atom.io/packages/gpp-compiler))**
* Add Option Panel **(modified from [rgbkrk/script](https://atom.io/packages/script))**
* Add config for compiler flags and run arguments
* Add error checking when compiling non-saved files
* Add notifications for the executed command and compiler output
* Add support for Windows, Ubuntu and Mac
