#!/usr/bin/env bash
set +e

VERSION="9.2.9.0"
# FULL_VERSION="${VERSION}"
# FULL_VERSION="${VERSION}-SNAPSHOT" # Uncomment to use a local snapshot
FULL_VERSION="${VERSION}-20190822.050313-17" # Uncomment to use a remote snapshot
JAR_FILE="jruby-complete-${FULL_VERSION}.jar"
M2_CACHED_JAR="$HOME/.m2/repository/org/jruby/jruby-complete/${FULL_VERSION}/${JAR_FILE}"
DOWNLOAD_DIR="$HOME/Downloads"
DOWNLOADED_JAR="${DOWNLOAD_DIR}/${JAR_FILE}"

cd libs
rm -f bcpkix-jdk15on-*.jar bcprov-jdk15on-*.jar bctls-jdk15on-*.jar cparse-jruby.jar generator.jar jline-*.jar jopenssl.jar jruby-complete-*.jar parser.jar psych.jar readline.jar snakeyaml-*.jar

# Try from local repository
if [[ ! -f "${M2_CACHED_JAR}" ]] ; then
  echo No "${M2_CACHED_JAR}" - Downloading.
  set +e
  mvn dependency:get -DremoteRepositories=http://repo1.maven.org/maven2/ \
                 -DgroupId=org.jruby -DartifactId=jruby-complete -Dversion=${FULL_VERSION}
  set -e
fi

if [[ -f "${M2_CACHED_JAR}" ]] ; then
  cp -a ${M2_CACHED_JAR} .
else
  # Snapshot version
  if test -f "${DOWNLOADED_JAR}"; then
    echo "Found downloaded JAR"
  else
    echo No "${DOWNLOADED_JAR}" - Downloading.
    wget "https://oss.sonatype.org/content/repositories/snapshots/org/jruby/jruby-complete/${VERSION}-SNAPSHOT/${JAR_FILE}" -P "${DOWNLOAD_DIR}/"
  fi
  cp ${DOWNLOADED_JAR} .
fi

unzip -j ${JAR_FILE} '*.jar'

# FIXME(uwe): Why do we delete these files?
zip generator.jar -d json/ext/ByteListTranscoder.class
zip generator.jar -d json/ext/OptionsReader.class
zip generator.jar -d json/ext/Utils.class
zip generator.jar -d json/ext/RuntimeInfo.class

cd - >/dev/null

cd src/main/java
find * -type f | grep "org/jruby/" | sed -e 's/\.java//g' | sort > ../../../overridden_classes.txt
cd - >/dev/null

while read p; do
  unzip -Z1 libs/${JAR_FILE} | grep "$p\\.class" > classes.txt
  unzip -Z1 libs/${JAR_FILE} | egrep "$p(\\\$[^$]+)*\\.class" >> classes.txt
  if [[ -s classes.txt ]] ; then
    zip -d -@ libs/${JAR_FILE} <classes.txt
    if [[ ! "$?" == "0" ]] ; then
      zip -d libs/${JAR_FILE} "$p\\.class"
    fi
  fi
  rm classes.txt
done < overridden_classes.txt

rm overridden_classes.txt
