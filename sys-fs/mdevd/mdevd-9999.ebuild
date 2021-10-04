# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="A mdev-compatible Linux hotplug manager daemon"
HOMEPAGE="https://skarnet.org/software/${PN}/"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.skarnet.org/${PN}"
	RDEPEND=">=dev-libs/skalibs-2.11.0.0"
else
	SRC_URI="${HOMEPAGE}${P}.tar.gz"
	if [[ "${PV}" = 0.1.2.0 ]]; then
		KEYWORDS="amd64 x86"
		RDEPEND=">=dev-libs/skalibs-2.9.3.0"
	else
		KEYWORDS="~amd64 ~x86"
		RDEPEND=">=dev-libs/skalibs-2.11.0.0"
	fi
fi

LICENSE="ISC"
SLOT="0"

DEPEND="${RDEPEND}
	sys-kernel/linux-headers
"

src_configure() {
	econf \
		--dynlibdir="/usr/$(get_libdir)" \
		--libdir="/usr/$(get_libdir)/${PN}" \
		--with-sysdeps="/usr/$(get_libdir)/skalibs"
}