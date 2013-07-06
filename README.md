A simple ANT+IVY build system
=============================

Simply check out this project as a submodule called "build" in your project

    git submodule add ssh://git@github.com/pfumagalli/build.git build
    git submodule update --init

Then add a basic `ivy.xml` file:

    <ivy-module version="2.0">

      <info organisation="com.github.pfumagalli" module="testproject" revision="1.2.3"/>

      <configurations>
        <conf name="default" visibility="public"/>
        <conf name="compile" visibility="private" extends="default"/>
        <conf name="testing" visibility="private" extends="compile"/>
      </configurations>

      <publications>
        <artifact name="testproject" type="binary" ext="jar" conf="default"/>
        <artifact name="testproject" type="source" ext="jar" conf="default"/>
      </publications>

      <dependencies>
        <dependency org="org.apache.logging" name="log4j" rev="1.2.17" conf="default"/>
      </dependencies>

    </ivy-module>

And finally a simple Ant `build.xml` file:

    <project>
      <import file="build/build.xml"/>
    </project>
