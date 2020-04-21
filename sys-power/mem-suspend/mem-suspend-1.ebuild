# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user toolchain-funcs

DESCRIPTION="The simplest script for suspending to memory"
HOMEPAGE="https://nymphos.ga/"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}"

pkg_setup() {
	enewgroup power
}

src_compile() {
	"$(tc-getCC)" "${FILESDIR}/${PN}.c" -o "${PN}"
}

src_install() {
	dobin "${PN}"
	fowners root:power "/usr/bin/${PN}"
	fperms 4710 "/usr/bin/${PN}"
}
