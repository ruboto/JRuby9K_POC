#!/usr/bin/env bash -e

VERSION="9.2.7.0"

cd libs
rm -f bcpkix-jdk15on-*.jar bcprov-jdk15on-*.jar bctls-jdk15on-*.jar cparse-jruby.jar generator.jar jline-*.jar jopenssl.jar jruby-complete-*.jar parser.jar psych.jar readline.jar snakeyaml-*.jar

cp -a ~/.m2/repository/org/jruby/jruby-complete/${VERSION}/jruby-complete-${VERSION}.jar .

unzip -j jruby-complete-${VERSION}.jar '*.jar'
# rm jline-2.11.jar

zip generator.jar -d json/ext/ByteListTranscoder.class
zip generator.jar -d json/ext/OptionsReader.class
zip generator.jar -d json/ext/Utils.class
zip generator.jar -d json/ext/RuntimeInfo.class

cd - >/dev/null

cd src/main/java
find * -type f | grep "org/jruby/" | sed -e 's/\.java//g' | sort > ../../../overridden_classes.txt
cd - >/dev/null

while read p; do
  unzip -Z1 libs/jruby-complete-${VERSION}.jar | grep "$p\\.class" > classes.txt
  unzip -Z1 libs/jruby-complete-${VERSION}.jar | egrep "$p(\\\$[^$]+)*\\.class" >> classes.txt
  if [[ -s classes.txt ]] ; then
    zip -d -@ libs/jruby-complete-${VERSION}.jar <classes.txt
    if [[ ! "$?" == "0" ]] ; then
      zip -d libs/jruby-complete-${VERSION}.jar "$p\\.class"
    fi
  fi
  rm classes.txt
done < overridden_classes.txt

rm overridden_classes.txt
