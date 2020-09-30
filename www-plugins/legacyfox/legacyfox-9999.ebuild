# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="Legacy bootstrapped extensions for Firefox 65 and beyond"
HOMEPAGE="https://git.gir.st/LegacyFox.git"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	MY_COMMIT="022cf6d"
	MY_PV="${PV}-${MY_COMMIT}"
	MY_P="LegacyFox-v${MY_PV}"
	SRC_URI="${HOMEPAGE}/snapshot/v${PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="amd64 x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="MPL-2.0"
SLOT="0"

src_compile() {
	:
}

src_install() {
	insinto "/usr/$(get_libdir)/firefox"
	doins config.js legacy.manifest
	doins -r defaults legacy
}
