# [Choice] Ubuntu version
ARG VARIANT="kinetic"
FROM ubuntu:${VARIANT}

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends wget software-properties-common \
    && wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    && apt-add-repository "deb http://apt.llvm.org/kinetic/ llvm-toolchain-kinetic-15 main" \
    && apt-get update \
    && apt-get -y install --no-install-recommends clang-15 lldb-15 lld-15 libc++-15-dev libc++abi-15-dev git make cppcheck valgrind
