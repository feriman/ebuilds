# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="A system tray extension for Thunderbird 68+"
HOMEPAGE="https://github.com/Ximi1970/systray-x"
EGIT_REPO_URI="https://github.com/Ximi1970/systray-x"

if [[ "${PV}" == 9999 ]]; then
	EGIT_BRANCH="develop"
else
	EGIT_COMMIT="${PV}"
	KEYWORDS="amd64 ~x86"
fi

LICENSE="MPL-2.0"
SLOT="0"
IUSE="+kde"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	kde? (
		kde-frameworks/knotifications:5
	)
"

RDEPEND="${DEPEND}
	|| ( >=mail-client/thunderbird-68
		>=mail-client/thunderbird-bin-68
	)
"

BDEPEND="app-arch/zip"

src_prepare() {
	default
	sed -i "s/qmake-qt5/qmake5/g" Makefile || die
}

src_compile() {
	if ! use kde; then
		emake OPTIONS="DEFINES+=NO_KDE_INTEGRATION"
	else
		emake
	fi
}

src_install() {
	dobin SysTray-X
	insinto /usr/lib64/thunderbird/extensions/
	doins systray-x@Ximi1970.xpi
	dodoc README.md README.preferences.md
}
