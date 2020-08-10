# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rpm

DESCRIPTION="ODBC Driver for Microsoft SQL Server"
HOMEPAGE="http://technet.microsoft.com/en-us/library/hh568451.aspx"
SRC_URI="https://packages.microsoft.com/rhel/7/prod/${P}-1.x86_64.rpm -> ${P}.rpm"

LICENSE="EULA"
SLOT="0"
KEYWORDS="amd64"

# All these dependencies were found from an ldd command on the main .so file of
# the driver.
RDEPEND="
	virtual/krb5
	net-misc/curl
	sys-libs/zlib
	dev-libs/gmp:0=
	dev-db/unixODBC
	dev-libs/nettle
	net-dns/libidn2
	net-libs/gnutls
	net-libs/libssh2
	net-nds/openldap
	sys-apps/keyutils
	dev-libs/libtasn1
	dev-libs/openssl:0=
	dev-libs/libltdl:0=
	sys-apps/util-linux
	dev-libs/libunistring
	sys-libs/e2fsprogs-libs"

DEPEND="
	${RDEPEND}
	dev-util/patchelf"

S="${WORKDIR}"

src_install () {
	# a quick and dirty helper function
	dodinsto () {
		local dir="${1}"
		dodir "${dir}"
		insinto "${dir}"
	}

	# first, let's create the "base" directory to put MS stuff into
	local base=opt/microsoft/msodbcsql
	dodir "/${base}"

	# .rll file
	local buf="${base}/share/resources/en_US"
	dodinsto "/${buf}"
	doins "${buf}/msodbcsqlr13.rll"

	# .ini file
	buf="${base}/etc"
	dodinsto "/${buf}"
	doins "${buf}/odbcinst.ini"

	# include file
	buf="${base}/include"
	dodinsto "/${buf}"
	doins "${buf}/msodbcsql.h"

	# shared objects
	buf="${base}/lib64"
	dodinsto "/${buf}"

	# let's go banana :(
	# we're installing a shared object in a very unusual place
	insopts -m0755
	doins "${buf}/libmsodbcsql-13.1.so.9.0"

	# yes, life is tough
	dosym /usr/lib/libcrypto.so.1.0.0 "${buf}/libcrypto.so.10"
	dosym /usr/lib/libssl.so.1.0.0 "${buf}/libssl.so.10"

	# patchelf because Microsoft
	einfo "Calling patchelf --set-rpath /${buf} ${D}/${buf}/libmsodbcsql-13.1.so.9.0"
	patchelf --set-rpath "/${buf}" "${D}/${buf}/libmsodbcsql-13.1.so.9.0" || die
	eend $?

	# aaaannnd we're back to normal...
	insopts -m0644
	dodoc usr/share/doc/msodbcsql/{LICENSE.txt,RELEASE_NOTES}
}

pkg_config() {
	/usr/bin/odbcinst -i -d -f /opt/microsoft/msodbcsql/etc/odbcinst.ini || die
}

pkg_postinst() {
	elog "If this is a new install, please run the following command"
	elog "to configure the Microsoft SQL ODBC drivers and sources:"
	elog "emerge --config =${CATEGORY}/${PF}"
}
