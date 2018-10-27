Name:           simplechroot
Version:        1.0.0
Release:        0
Summary:        Chroot with ease
BuildArch:	noarch
License:        GPLv3
URL:            https://gitlab.com/BobyMCbobs/%{name}
Source0:        https://gitlab.com/BobyMCbobs/%{name}/-/archive/%{version}/%{name}-%{version}.zip


%description
Setup a chroot with ease.


%prep
%autosetup


%install
%{__make} DESTDIR=$RPM_BUILD_ROOT install


%files
%license LICENSE
%doc README.md
/usr/bin/%{name}


%changelog
* Sat Oct 27 2018 caleb
- Initial rpm spec