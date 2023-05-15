#!/usr/bin/env bash
set -e

VERSION="9.4.2.0"
FULL_VERSION="${VERSION}"
# FULL_VERSION="${VERSION}-SNAPSHOT" # Uncomment to use a local snapshot
# FULL_VERSION="${VERSION}-20190822.050313-17" # Uncomment to use a remote snapshot
JAR_FILE="jruby-complete-${FULL_VERSION}.jar"
DOWNLOAD_DIR="$HOME/Downloads"
DOWNLOADED_JAR="${DOWNLOAD_DIR}/${JAR_FILE}"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR

[ ! -d $HOME/Downloads ] && mkdir $HOME/Downloads  # Create the directory if we don't find it
[ ! -d ./libs ] && mkdir ./libs                    # Create the directory if we don't find it

cd libs
rm -f bcpkix-jdk15on-*.jar bcprov-jdk15on-*.jar bctls-jdk15on-*.jar cparse-jruby.jar generator.jar jline-*.jar jopenssl.jar jruby-complete-*.jar parser.jar psych.jar readline.jar snakeyaml-*.jar

if test -f "${DOWNLOADED_JAR}"; then
  echo "Found downloaded JAR"
else
  echo No "${DOWNLOADED_JAR}" - Downloading.
  curl "https://oss.sonatype.org/service/local/repositories/releases/content/org/jruby/jruby-complete/${VERSION}/jruby-complete-${VERSION}.jar" -o "${DOWNLOADED_JAR}"
fi
cp ${DOWNLOADED_JAR} .

unzip -o -j ${JAR_FILE} '*.jar'

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

cd libs
rm -f digest.jar
cd - >/dev/null
