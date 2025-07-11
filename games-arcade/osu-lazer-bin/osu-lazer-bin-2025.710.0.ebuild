# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="osu-lazer"

DESCRIPTION="A free-to-win rhythm game. Rhythm is just a *click* away!"
HOMEPAGE="https://osu.ppy.sh/"
SRC_URI="https://github.com/ppy/osu/releases/download/${PV}-lazer/osu.AppImage -> osu-${PV}.AppImage"
S="${WORKDIR}"

LICENSE="MIT CC-BY-NC-4.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="strip"

RDEPEND="
	sys-fs/fuse:0
	sys-libs/zlib
	virtual/opengl"

src_unpack() {
	:
}

src_install() {
	newbin "${FILESDIR}/${MY_PN}.sh" "${MY_PN}"

	insinto "/opt/${MY_PN}"
	newins "${DISTDIR}/osu-${PV}.AppImage" osu.AppImage
	fperms +x "/opt/${MY_PN}/osu.AppImage"
}
