#!/usr/bin/env bash -e

BRANCH="9.2.8.0"
VERSION="${BRANCH}-20190729.233104-80"
JAR_FILE="jruby-complete-${VERSION}.jar"
M2_CACHED_JAR="~/.m2/repository/org/jruby/jruby-complete/${VERSION}/jruby-complete-${VERSION}.jar"
eval "DOWNLOAD_DIR=~/Downloads"
DOWNLOADED_JAR="${DOWNLOAD_DIR}/${JAR_FILE}"

cd libs
rm -f bcpkix-jdk15on-*.jar bcprov-jdk15on-*.jar bctls-jdk15on-*.jar cparse-jruby.jar generator.jar jline-*.jar jopenssl.jar jruby-complete-*.jar parser.jar psych.jar readline.jar snakeyaml-*.jar

if test -f "${M2_CACHED_JAR}"; then
  cp -a ${M2_CACHED_JAR} .
else
  if test -f "${DOWNLOADED_JAR}"; then
    echo "Found downloaded JAR"
  else
    echo No "${M2_CACHED_JAR}" or "${DOWNLOADED_JAR}" - Downloading.
    wget "https://oss.sonatype.org/content/repositories/snapshots/org/jruby/jruby-complete/${BRANCH}-SNAPSHOT/${JAR_FILE}" -P "${DOWNLOAD_DIR}/"
  fi
  cp ${DOWNLOADED_JAR} .
fi

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
