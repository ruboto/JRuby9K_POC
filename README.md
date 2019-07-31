# JRuby9K_POC
Proof of concept for using JRuby 9K in a Ruboto project

This repository contains a sample Android Studio project using JRuby.

## Adding JRuby to an AndroidStudio project

* Copy jruby-complete-9.2.x.x.jar into `app/libs`

* Extract the vendored jars into `app/libs`

  `unzip -j app/libs/jruby-complete-9.2.x.x.jar *.jar -d app/libs/`
  
    inflating: app/libs/jline-2.11.jar  
    inflating: app/libs/jline-2.14.6.jar  
    inflating: app/libs/jopenssl.jar   
    inflating: app/libs/generator.jar  
    inflating: app/libs/parser.jar     
    inflating: app/libs/bcpkix-jdk15on-1.59.jar  
    inflating: app/libs/bcprov-jdk15on-1.59.jar  
    inflating: app/libs/bctls-jdk15on-1.59.jar  
    inflating: app/libs/snakeyaml-1.23.jar  
    inflating: app/libs/psych.jar      
    inflating: app/libs/cparse-jruby.jar  
    inflating: app/libs/readline.jar 

* Delete duplicate `app/libs/jline-2.11.jar`

* Delete duplicate JSON classes

    zip app/libs/generator.jar -d json/ext/ByteListTranscoder.class
    zip app/libs/generator.jar -d json/ext/OptionsReader.class
    zip app/libs/generator.jar -d json/ext/Utils.class
    zip app/libs/generator.jar -d json/ext/RuntimeInfo.class