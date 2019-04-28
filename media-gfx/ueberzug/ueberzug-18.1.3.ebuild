# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="A command line utility which display images in X11 terminals"
HOMEPAGE="https://github.com/seebye/ueberzug"
SRC_URI="https://github.com/seebye/ueberzug/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/python-xlib[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	x11-libs/libXext
"

PATCHES=( "${FILESDIR}/${PN}-pillow.patch" )