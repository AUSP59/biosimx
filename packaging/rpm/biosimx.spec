Name:           biosimx
Version:        1.0.0
Release:        1%{?dist}
Summary:        Deterministic C++ biosimulation engine
License:        MIT
URL:            https://example.org/biosimx
BuildRequires:  cmake, gcc-c++, ninja-build
%description
BioSimX CLI.

%build
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build -j

%install
mkdir -p %{buildroot}/usr/bin
install -m 0755 build/bin/biosimx %{buildroot}/usr/bin/biosimx

%files
/usr/bin/biosimx
