# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Make X11 BDF fonts bold and/or italic"
HOMEPAGE="http://hp.vector.co.jp/authors/VA013651/freeSoftware/mkbold-mkitalic.html"
SRC_URI="http://hp.vector.co.jp/authors/VA013651/lib/${P}.tar.bz2"

LICENSE="XOrg"
SLOT="0"
KEYWORDS="amd64 x86"

src_install() {
	emake DESTDIR="${D}" prefix=/usr install
	dodoc README
}