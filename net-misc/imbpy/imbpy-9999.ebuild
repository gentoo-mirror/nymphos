# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 git-r3

DESCRIPTION="A python interface for imageboards"
HOMEPAGE="https://gitgud.io/ring/${PN}"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="ISC"
SLOT="0"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${PN}-setup.py.patch" )
