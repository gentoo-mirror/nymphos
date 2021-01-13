# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils multilib multilib-minimal

DESCRIPTION="Adobe Flash Player"
HOMEPAGE="
	https://www.adobe.com/products/flashplayer.html
	https://get.adobe.com/flashplayer/
	https://helpx.adobe.com/security/products/flash-player.html
"

AF_URI="https://fpdownload.macromedia.com/pub/flashplayer/pdc/${PV}"
AF_D_URI="https://fpdownload.macromedia.com/pub/flashplayer/updaters/${PV%%.*}"
SRC_URI="
	!debug? (
		nsplugin? (
			abi_x86_32? ( ${AF_URI}/flash_player_npapi_linux.i386.tar.gz -> flash_player_npapi_linux-${PV}-i386.tar.gz )
			abi_x86_64? ( ${AF_URI}/flash_player_npapi_linux.x86_64.tar.gz -> flash_player_npapi_linux-${PV}-x86_64.tar.gz )
		)
		ppapi? (
			abi_x86_32? ( ${AF_URI}/flash_player_ppapi_linux.i386.tar.gz -> flash_player_ppapi_linux-${PV}-i386.tar.gz )
			abi_x86_64? ( ${AF_URI}/flash_player_ppapi_linux.x86_64.tar.gz -> flash_player_ppapi_linux-${PV}-x86_64.tar.gz )
		)
	)
	debug? (
		nsplugin? (
			abi_x86_32? ( ${AF_D_URI}/flash_player_npapi_linux_debug.i386.tar.gz -> flash_player_npapi_linux_debug-${PV}-i386.tar.gz )
			abi_x86_64? ( ${AF_D_URI}/flash_player_npapi_linux_debug.x86_64.tar.gz -> flash_player_npapi_linux_debug-${PV}-x86_64.tar.gz )
		)
		ppapi? (
			abi_x86_64? ( ${AF_D_URI}/flash_player_ppapi_linux_debug.x86_64.tar.gz -> flash_player_ppapi_linux_debug-${PV}-x86_64.tar.gz )
		)
	)
"

KEYWORDS="amd64 x86"
LICENSE="AdobeFlash-11.x"
SLOT="0"
IUSE="debug +nsplugin +ppapi"
REQUIRED_USE="
	|| ( nsplugin ppapi )
	debug? ( ppapi? ( !abi_x86_32 ) )
"

RESTRICT="bindist mirror strip"

RDEPEND="
	!www-plugins/chrome-binary-plugins[flash(-)]
	nsplugin? (
		dev-libs/atk[${MULTILIB_USEDEP}]
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		dev-libs/nspr[${MULTILIB_USEDEP}]
		dev-libs/nss[${MULTILIB_USEDEP}]
		media-libs/fontconfig[${MULTILIB_USEDEP}]
		media-libs/freetype[${MULTILIB_USEDEP}]
		>=sys-libs/glibc-2.4
		x11-libs/cairo[${MULTILIB_USEDEP}]
		x11-libs/gdk-pixbuf[${MULTILIB_USEDEP}]
		x11-libs/gtk+:2[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXcursor[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		x11-libs/libXrender[${MULTILIB_USEDEP}]
		x11-libs/libXt[${MULTILIB_USEDEP}]
		x11-libs/pango[${MULTILIB_USEDEP}]
	)
"

S="${WORKDIR}"

# Ignore QA warnings in these closed-source binaries, since we can't fix them:
QA_PREBUILT="usr/*"

src_unpack() {
	local files=( ${A} )

	multilib_src_unpack() {
		mkdir -p "${BUILD_DIR}" || die
		cd "${BUILD_DIR}" || die

		# we need to filter out the other archive(s)
		local other_abi
		[[ "${ABI}" == amd64 ]] && other_abi=i386 || other_abi=x86_64
		unpack ${files[@]//*${other_abi}*/}
	}

	multilib_parallel_foreach_abi multilib_src_unpack
}

src_prepare() {
	local files=( ${A} )

	multilib_src_prepare() {
		cd "${BUILD_DIR}" || die

		# we need to filter out the other archive(s)
		local other_abi file
		[[ "${ABI}" == amd64 ]] && other_abi=i386 || other_abi=x86_64
		for file in ${files[@]//*${other_abi}*/}; do
			eapply "${FILESDIR}/${file%.tar.gz}-defuse_time_bomb.patch"
		done
	}

	multilib_parallel_foreach_abi multilib_src_prepare

	default
}

multilib_src_install() {
	local pkglibdir="lib"
	[[ -d usr/lib64 ]] && pkglibdir="lib64"

	if use nsplugin; then
		exeinto "/usr/$(get_libdir)/nsbrowser/plugins"
		doexe libflashplayer.so

		if multilib_is_native_abi; then
			# No KDE applet, so allow the GTK utility to show up in KDE:
			sed \
				-i usr/share/applications/flash-player-properties.desktop \
				-e "/^NotShowIn=KDE;/d" || die

			# The userland 'flash-player-properties' standalone app:
			dobin usr/bin/flash-player-properties

			# Icon and .desktop for 'flash-player-properties'
			insinto /usr/share
			doins -r usr/share/{icons,applications}
			dosym ../icons/hicolor/48x48/apps/flash-player-properties.png \
				/usr/share/pixmaps/flash-player-properties.png
		fi

		# The magic config file!
		insinto "/etc/adobe"
		doins "${FILESDIR}/mms.cfg"
	fi

	if use ppapi; then
		exeinto "/usr/$(get_libdir)/chromium/PepperFlash"
		doexe libpepflashplayer.so
		insinto "/usr/$(get_libdir)/chromium/PepperFlash"
		doins manifest.json

		if multilib_is_native_abi; then
			dodir /etc/chromium
			sed "${FILESDIR}"/pepper-flash-r1 \
				-e "s|@FP_LIBDIR@|$(get_libdir)|g" \
				-e "s|@FP_PV@|${PV}|g" \
				>"${D}/etc/chromium/pepper-flash" \
				|| die
		fi
	fi
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}