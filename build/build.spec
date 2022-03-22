Name:           docker-volume-rbd
Version:        %{VERSION}
Release:        0%{?dist}
Summary:        Docker volume plugin to support S3 storage backends
Group:          System Environment/Daemons
License:        MIT License
URL:            https://www.aventer.biz

Obsoletes:  docker-volume-rbd < %{version}-%{release}
Provides:	 docker-volume-rbd = %{version}-%{release}
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

%description
Docker volume plugin to support RBD storage backends


%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/bin/
mkdir -p $RPM_BUILD_ROOT/etc/docker-volume/
mkdir -p $RPM_BUILD_ROOT/usr/lib/systemd/system

cp /root/docker-volume-rbd/build/docker-volume-rbd $RPM_BUILD_ROOT/usr/bin/docker-volume-rbd
cp /root/docker-volume-rbd/build/docker-volume-rbd.service $RPM_BUILD_ROOT/usr/lib/systemd/system/docker-volume-rbd.service
cp /root/docker-volume-rbd/build/rbd.env $RPM_BUILD_ROOT/etc/docker-volume/rbd.env
chmod +x $RPM_BUILD_ROOT/usr/bin/docker-volume-rbd

%files
/usr/bin/docker-volume-rbd
/etc/docker-volume/rbd.env
/usr/lib/systemd/system/docker-volume-rbd.service
