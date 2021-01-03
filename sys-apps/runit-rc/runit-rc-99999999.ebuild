# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Runit scripts from the Void Linux project"
HOMEPAGE="https://github.com/void-linux/void-runit"
if [[ "${PV}" = 99999999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> void-runit-${PV}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="CC0-1.0"
SLOT="0"

RDEPEND="
	sys-process/runit
	sys-process/procps
	virtual/awk
	sys-apps/util-linux[tty-helpers]
	!!sys-apps/sysvinit
"

PATCHES=(
	"${FILESDIR}/void-runit-bugfix.patch"
	"${FILESDIR}/void-runit-gentoo.patch"
)

S="${WORKDIR}/void-runit-${PV}"

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install

	# put sbin in the root
	mv "${D}/usr/sbin" "${D}"
	# remove dracut configuration
	rm -rf "${D}/usr/lib"

	keepdir /etc/zzz.d/{suspend,resume}
	dodoc README.md

	# compatibility symlink
	dosym /run/runit/runsvdir/current /var/service
	# provide init
	dosym runit-init /sbin/init
}
