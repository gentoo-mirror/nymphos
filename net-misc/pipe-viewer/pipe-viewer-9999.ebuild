# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop optfeature perl-module xdg-utils

DESCRIPTION="A lightweight YouTube client for Linux (fork of straw-viewer)"
HOMEPAGE="https://github.com/trizen/${PN}"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="Artistic-2"
SLOT="0"
IUSE="gtk gtk2"

REQUIRED_USE="gtk2? ( gtk )"

RDEPEND="
	dev-perl/Data-Dump
	dev-perl/JSON
	dev-perl/libwww-perl[ssl]
	dev-perl/Term-ReadLine-Gnu
	dev-perl/LWP-Protocol-https
	virtual/perl-Encode
	virtual/perl-File-Path
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	virtual/perl-Scalar-List-Utils
	virtual/perl-Term-ANSIColor
	virtual/perl-Term-ReadLine
	virtual/perl-Text-ParseWords
	virtual/perl-Text-Tabs+Wrap
	gtk? (
		gtk2? (
			>=dev-perl/Gtk2-1.244.0
		)
		!gtk2? (
			dev-perl/Gtk3
		)
		dev-perl/File-ShareDir
		virtual/freedesktop-icon-theme
		x11-libs/gdk-pixbuf:2[X,jpeg]
	)
	|| ( >=media-video/ffmpeg-4.1.3[openssl,-libressl] >=media-video/ffmpeg-4.1.3[-openssl,libressl] >=media-video/ffmpeg-4.1.3[gnutls] )
	|| ( media-video/mpv media-video/mplayer media-video/vlc gtk? ( media-video/smplayer ) )"
DEPEND="dev-perl/Module-Build"

src_configure() {
	local myconf
	if use gtk; then
		if use gtk2; then
			myconf="--gtk2"
		else
			myconf="--gtk3"
		fi
	fi

	perl-module_src_configure
}

src_install() {
	perl-module_src_install

	if use gtk; then
		domenu share/gtk-pipe-viewer.desktop
		doicon share/icons/gtk-pipe-viewer.png
	fi
}

pkg_postinst() {
	use gtk && xdg_icon_cache_update
	elog "Optional dependencies:"
	optfeature "cache support" dev-perl/LWP-UserAgent-Cached
	optfeature "faster JSON to HASH conversion" dev-perl/JSON-XS
	optfeature "the case if there are SSL problems" dev-perl/Mozilla-CA
	optfeature "printing results in a fixed-width format (--fixed-width, -W)" dev-perl/Text-CharWidth
	optfeature "live streams support" net-misc/youtube-dl
	optfeature "threads support" virtual/perl-threads
	elog
	elog "Check the configuration file in ~/.config/pipe-viewer/"
	elog "and configure your video player backend."
}

pkg_postrm() {
	use gtk && xdg_icon_cache_update
}