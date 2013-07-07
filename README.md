A simple ANT+IVY build system
=============================

Simply check out this project as a submodule called "build" in your project

    git submodule add ssh://git@github.com/pfumagalli/build.git build
    git submodule update --init

Then add a basic Ant `build.xml` file:

    <project>
      <import file="build/build.xml"/>
    </project>

And finally create a basic `ivy.xml` file:

    <ivy-module version="2.0">

      <info organisation="com.github.pfumagalli" module="testproject" revision="1.2.3"/>

      <configurations>
        <conf name="default" visibility="public"/>
        <conf name="compile" visibility="private" extends="default"/>
        <conf name="testing" visibility="private" extends="compile"/>
      </configurations>

      <dependencies>
        <dependency org="org.apache.logging" name="log4j" rev="1.2.17" conf="default"/>
      </dependencies>

    </ivy-module>

Artifacts will be automatically generated from the public configurations (no
need to specify them). Source directories for each configuration should exist
under {{sources/_configuration_}}.
