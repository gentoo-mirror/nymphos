# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit udev user

DESCRIPTION="Comprehensive list of udev rules to connect to android devices"
HOMEPAGE="https://github.com/M0Rf30/${PN}"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="virtual/udev"
DEPEND="${RDEPEND}"

src_install() {
	udev_dorules 51-android.rules
}

pkg_setup() {
	enewgroup adbusers
}

pkg_postinst() {
	einfo "To be able to use android devices,"
	einfo "add yourself to the 'adbusers' group by calling"
	einfo "  usermod -a -G adbusers <user>"
}
