#!/bin/bash -x

OTEL_JAVA_VERSION=1.21.0
OTEL_JAVA_INSTRUMENTATION_VERSION=1.21.0
OTEL_CONTRIB_VERSION=1.21.0

SOURCE=${BASH_SOURCE[0]}
DIR=$( dirname "$SOURCE" )
OTEL_JAVA_PATCH="../.github/patchs/opentelemetry-java.patch"

if [[ -f "$OTEL_JAVA_PATCH" ]]; then
git clone https://github.com/open-telemetry/opentelemetry-java.git
cd opentelemetry-java
git checkout v${OTEL_JAVA_VERSION} -b tag-v${OTEL_JAVA_VERSION}
patch -p1 < ../${OTEL_JAVA_PATCH}


cd -
else
echo "Skiping patching opentelemetry-java"
fi

OTEL_JAVA_INSTRUMENTATION_PATCH="../.github/patchs/opentelemetry-java-instrumentation.patch"
if [[ -f "$OTEL_JAVA_INSTRUMENTATION_PATCH" ]]; then
git clone https://github.com/open-telemetry/opentelemetry-java-instrumentation.git

cd opentelemetry-java-instrumentation
git checkout v${OTEL_JAVA_INSTRUMENTATION_VERSION} -b tag-v${OTEL_JAVA_INSTRUMENTATION_VERSION}

patch -p1 < "../${OTEL_JAVA_INSTRUMENTATION_PATCH}"


# ./gradlew check -x spotlessCheck 
else
echo "Skipping patching opentelemetry-java-instrumentation"
fi

# continue with the rest of the process
