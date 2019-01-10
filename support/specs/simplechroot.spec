Name:           simplechroot
Version:        1.1.1
Release:        0
Summary:        Chroot with ease
Group:          System/Management
BuildArch:      noarch
License:        GPL-3.0
URL:            https://gitlab.com/BobyMCbobs/%{name}
Source0:        https://gitlab.com/BobyMCbobs/%{name}/-/archive/%{version}/%{name}-%{version}.zip
BuildRequires:	unzip


%description
Setup a chroot with ease.


%prep
%autosetup

%build

%install
%{__make} DESTDIR=$RPM_BUILD_ROOT install


%files
%license LICENSE
%doc README.md
/usr/bin/%{name}
/usr/share/bash-completion/completions/%{name}
/usr/share/metainfo/simplechroot.appdata.xml


%changelog
* Thu Nov 8 2018 caleb
- Update to version 1.1.0

* Sat Oct 27 2018 caleb
- Initial rpm spec