A simple ANT+IVY build system
=============================

Simply check out this project as a submodule called "build" in your project

    git submodule add ssh://git@github.com/pfumagalli/build.git build
    git submodule update --init

Then bootstrap the project by running Ant:

    ant -f build/bootstrap.xml

After a few question, the `ivy.xml` and `build.xml` files (plus all the support
files required to run *Eclipse*) will be generated in your current directory.
