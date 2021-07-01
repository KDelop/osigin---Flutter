# MCA FLUTTER

Medical Courier Application - Flutter mobile app.

## Establish Flutter

- ArchLinux 2020-01-16
- Install android studio and android emulator
- Observe the `bootstrap.archlinux.sh` script.


## Dev environment activation

Source this file and it will do some checks to set up your environment.

    source ./tasks/activate.sh

## Build

Prebuild step to establish environment. This will create an environment file with configuration values at build time. Observe this file to see variables that can be baked in to the build.

    dart tool/tools_env.dart

Other code generation steps handled by `build_runner` .. as of now we are generating data transfer objects for json mapping to types. (see `dto` folder)

    ./tasks/build.sh

This will launch the code and run in whatever emulator it can find. F5 in VSC has some milage too.

    flutter run

## Unit tests

Will run tests on save.

    ./tasks/test.sh
    ./tasts/test.sh --name="testname"
    ./tasks/test.sh ./tests/path/to/stuff_test.dart

VSCode is also detecting that functions in certain files are runnable tests.  Not sure if there is a test discoverer in VSC.

## Integration Tests

### Start Docker Services
    
    Currently has an httpbin but I could see eventually spinning up a backend.

    ./tasks/docker_int_test.sh up

### Run int tests

    ./tasks/test.sh ./int_test_new

Old int tests for reference in the `./int_test` folder

Integration tests run against a deployed server.. `test_env.dart` may be of interest for needed environment variable substitution.

## Deploy

![Build Status](https://app.bitrise.io/app/5fbee60866be9124/status.svg?token=fAeqDi9UriD1yy5cBZ9i3g&branch=master)

Currently on Bitrise.

### Tag a release

Following [semver](https://semver.org) practices.

#### Fetch the latest tags from remote

    $ git fetch --tags

#### Observe the current tags for the project

    $ git tag -l
    v0.0.50
    v0.0.51
    v0.1.0

#### Make a new tag and push it

    $ git tag v0.0.52
    $ git push --tags

This should trigger a new build on bitrise.  The resulting signed artifacts can be uploaded to the app stores.

## Commentary

### Object postfixing

TODO: elaborate

- Store
- ViewModel (Vm)
- DataTransferObject (Dto)

### AUR/Java Packaging

There's some dissonance between system installed java/android-studio and others.

I installed android studio through AUR but `android-sdk` should probably be installed via android-studio tooling becuase it's just going to be more up to date.  There is probably a way of automating this through the android `sdkmanager` util, but install location and JRE runtime (blows up on my `openjdk 11.0.5 2019-10-15` with some class not found error.)  Using the JRE that comes with android studio fixes this, but involves more env wangling.

There's some permissions issue with installing android-sdk via AUR.. assumes user writable.  Sort of messy but installing it for the local user may make sense at this time.

### VM Accel

TODO: Mention something about linux verification of enabling [VM Acceleration][0].  I had to enable it for a project last year and it made a huge difference. I vaugely recall some CLI recipes to help debug this.

### Flutter Doctor

Flutter doctor may be useful for debugging env issues

    flutter doctor

### VSCODE

Seems to detect when pubspec changes and obtains new packages.

### Linting

Linting is performed by the `flutter analyze` function.  There are recommended communiyts presets that are configured in `analysis_options.yml`

### State management

Using RxJS/Hooks seems alright thus far... but I am increasingly curious about [MobX][1] because it is my favorite ReactJS state framework ported to Dart.

### DI/IoC

It doesn't feel completely satisfactory in the DI/IoC realm. Looked at GetIt and Provider. The latter seems very promising for handling state down the Widget Tree.  For units that don't have a widget context it is more unclear.  GetIt depends on a global instance which doesn't feel right. Other option like googles unsupported injector seem to use a lot of code generation dragons.

### Flutter Storyboard

AKA Storybook for flutter. I had problems with it mostly because of how views/widgets handle sizing from parents, and if the parent is Storyboard stuff then things have to be rearranged.  It also seems like the widgets are rendered all at once instead of on nav, which was not compatible with how I arranged the views initially.

[0]: https://developer.android.com/studio/run/emulator-acceleration#accel-vm
[1]: https://mobx.pub/