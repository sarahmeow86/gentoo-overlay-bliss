# Copyright 2024 Gentoo Authors
# Distributed under the terms of the BSD-2 License

EAPI=8

DISTUTILS_USE_PEP517=poetry
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{11,12,13} )

inherit distutils-r1

DESCRIPTION="Generates an initramfs image with files needed to boot Gentoo Linux on OpenZFS"
HOMEPAGE="https://github.com/sarahmeow86/bliss-initramfs"
SRC_URI="https://github.com/sarahmeow86/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nvme test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/cpio
	app-shells/bash
	sys-apps/busybox
	sys-apps/grep
	sys-apps/kbd
	sys-apps/kmod[lzma]
	sys-fs/zfs
	sys-fs/zfs-kmod
	|| (
		sys-fs/udev
		sys-fs/eudev
		sys-apps/systemd
	)
	nvme? ( sys-block/nvme-cli )
	${PYTHON_DEPS}
"

DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-python/poetry-core-1.0.0[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${P}-settings-path.patch
)

distutils_enable_tests pytest

src_prepare() {
	default
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /usr/share/bliss-initramfs
	doins files/default-settings.json
	doins files/init

	dodoc README.md USAGE.md
}
	newins "${S}/files/default-settings.json" settings.json

	# Make the script executable
	python_fix_shebang "${ED}"/usr/bin/mkinitrd.py
	fperms +x /usr/bin/mkinitrd.py
}

pkg_postinst() {
	elog "bliss-initramfs has been installed."
	elog "To create an initramfs, run: mkinitrd.py -k \$(uname -r)"
	elog "For NVMe support, enable the nvme USE flag"
	elog "Documentation can be found at: ${HOMEPAGE}"
}