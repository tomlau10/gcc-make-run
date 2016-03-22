# GCC Make Run Package

Compile-run C/C++ source code and execute Makefile in Atom.



## Preface

I am a Windows user and just switched to Atom from Notepad++. Previously I wrote a script in NppExec to compile-run my C/C++ programs and execute Makefiles with customizable compile flags and run options. Atom has numerous community packages and I have tried some. They are really great in certain extent but still cannot fully satisfy my need. Therefore I decided to reference their packages and make my own.



## Features

* Compile the current actively opened C/C++ file
* Execute the current actively opened Makefile
* Execute Makefile from Tree View
* Customize compilers used
* Customize compiler flags
* Customize run options
* Shortcut to compile-run [ default: `f6` ]
* Shortcut to access run options panel [ default: `ctrl-f6`/`cmd-f6` ]



## Setup
I have tested in the following three platforms:

### Windows
For Windows users, I recommend installing the [**TDM-GCC**](http://tdm-gcc.tdragon.net/) (*which I am using*), then go to the setting page of this package and change the make utility to `mingw32-make`, after that everything should work. If you have installed other gcc-compilers, just make sure their command names are in you `PATH` environment variable

### Ubuntu
For Ubuntu users, `gcc` and `make` should have already been installed, though you may need to install `g++` in addition.

### Mac
For Mac users, Xcode is not a prerequisite but you need to at least install the **Xcode Command Line Tools**. [This](http://railsapps.github.io/xcode-command-line-tools.html) site has a more detailed walkthrough.



## Usage

### Settings Page
![Settings Page](https://raw.githubusercontent.com/tomlau10/gcc-make-run/master/images/settings.gif)
* Edit compiler command name or path
* Edit compiler flags and run arguments
* Toggle unconditional build

### Run Options
![Run Options](https://raw.githubusercontent.com/tomlau10/gcc-make-run/master/images/options.gif)
* Quick access to edit flags and arguments
* Can use `[shift-]tab` to change input focus and `enter` to trigger the `run` button
* Can trigger one-time unconditional build here

### Context Menu
![Context Menu](https://raw.githubusercontent.com/tomlau10/gcc-make-run/master/images/menu.gif)
* Trigger Make-Run on Makefile from tree view
* To execute a Makefile, a `run` target need to be specified, just as in the above `.gif`  
  **Note**: Arguments in run options will be passed as environment variable `ARGS` to the Makefile, but compiler flags and link libraries will not. Below is an example `run` target:  

  ```Makefile
  ...
  run:
    testing $(ARGS)
  ...
  ```



## Code and Repo Reference
I am new in CoffeeScript and know little about the Model-View-Controller design, thus my code may be messy. Below are the packages that I used and the repositories that I have referenced. They are great and you may want to try them out!
* [kriscross07/atom-gpp-compiler](https://atom.io/packages/gpp-compiler)  
  \+ A simple but useful package to compile-run C/C++ files  
  \- Cannot customize run arguments  
  \- On windows the cmd console just flash then close after the C/C++ program ends  
  \! The closest that I want, thus mine is a **remake with enhancements**  

* [rgbkrk/atom-script](https://atom.io/packages/script)  
  \+ Support many languages  
  \+ Customizable compile and run flags  
  \- Does not support C/C++ on Windows...  
  \- Does not support interactive running  
  \! The option view is **modified from this package**  

* [ksxatompackages/cmd-exec](https://atom.io/packages/command-executor)  
  \+ Can register commands to do many things  
  \- Troublesome to set up  

* [noseglid/atom-build](https://atom.io/packages/build)  
  \+ Support automated build  
  \- Need to specify an auto-build file  
