FROM mcr.microsoft.com/devcontainers/cpp:1-debian-12

# [Optional] Uncomment this section to install additional vcpkg ports.
# RUN su vscode -c "${VCPKG_ROOT}/vcpkg install <your-port-name-here>"

# [Optional] Uncomment this section to install additional packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

RUN apt-get install ca-certificates gpg wget \
    && wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null \
	&& echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null \
	&& apt-get update \
	&& apt-get install -y cmake

RUN apt-get install python3-venv python3-pip -y

RUN apt-get install software-properties-common python3-launchpadlib -y
RUN echo "deb http://deb.debian.org/debian unstable main" > /etc/apt/sources.list.d/unstable.list \
    && cat <<EOF > /etc/apt/preferences.d/unstable
Package: *
Pin: release a=unstable
Pin-Priority: 50
EOF

RUN apt-get update \
	&& apt-get install -y gcc-14 g++-14 \
	&& update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 100 \
	&& update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-14 100 \
	&& apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get autoremove python3-lldb-* -y
RUN wget https://apt.llvm.org/llvm.sh \
	&& chmod +x llvm.sh \
	&& ./llvm.sh 18 all \
	&& update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-18 100 \
	&& update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-18 100 \
	&& apt-get clean \
    && rm -rf /var/lib/apt/lists/*	 

RUN apt-get update \
	&& apt-get install -y cppcheck \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
