# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=7

DESCRIPTION="Backend-agnostic network configuration in YAML"
HOMEPAGE="https://netplan.io/"
SRC_URI="https://github.com/CanonicalLtd/${PN}/archive/${PV}/${PV}.tar.gz"
LICENSE="GPLv3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

DEPEND="app-shells/bash-completion
		app-text/pandoc
		dev-libs/glib
		dev-libs/libyaml
		dev-python/netifaces
		dev-python/pyyaml
		sys-apps/systemd"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	emake \
		DESTDIR="$D" \
		DOCDIR="/usr/share/doc/${PF}" \
		LIBDIR=$(get_libdir) \
		LIBEXECDIR=$(get_libdir) \
		ROOTLIBEXECDIR=$(get_libdir) \
	install
}
