#!/bin/bash -x

OTEL_JAVA_VERSION=1.21.0
OTEL_JAVA_INSTRUMENTATION_VERSION=1.21.0
OTEL_CONTRIB_VERSION=1.21.0


PATCH_VERSION=1.21.1-adot
mkdir tmp
cd tmp

if [[ -f ../patchs/opentelemetry-java.patch ]]; then
git clone https://github.com/open-telemetry/opentelemetry-java.git
cd opentelemetry-java
git checkout v${OTEL_JAVA_VERSION} -b tag-v${OTEL_JAVA_VERSION}
patch -p1 < ../../patchs/opentelemetry-java.patch

git commit -a -m "Patched version ${PATCH_VERSION}"

./gradlew build && ./gradlew publishToMavenLocal

cd -
else
echo "Skiping patching opentelemetry-java"
fi

if [[ -f ../patchs/opentelemetry-java-instrumentation.patch]]; then
git clone https://github.com/open-telemetry/opentelemetry-java-instrumentation.git

cd opentelemetry-java-instrumentation
git checkout v${OTEL_JAVA_INSTRUMENTATION_VERSION} -b tag-v${OTEL_JAVA_INSTRUMENTATION_VERSION}

patch -p1 < ../../patchs/opentelemetry-java-instrumentation.patch

git commit -a -m "Patched version ${PATCH_VERSION}"

./gradlew check -x spotlessCheck && ./gradlew publishToMavenLocal
else
echo "Skipping patching opentelemetry-java-instrumentation"
fi

# continue with the rest of the process
