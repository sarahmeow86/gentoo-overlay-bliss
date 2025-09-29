# Copyright 2024 Gentoo Authors
# Distributed under the terms of the BSD-2 License

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11,12,13} )

inherit distutils-r1

DESCRIPTION="Generates an initramfs image with files needed to boot Gentoo Linux on OpenZFS"
HOMEPAGE="https://github.com/sarahmeow86/bliss-initramfs"
SRC_URI="https://github.com/sarahmeow86/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nvme"

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
"

DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-python/poetry-core-1.0.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	default
	# Ensure the default settings file is installed
	mkdir -p "${S}/files" || die
	cp "${S}/files/default-settings.json" "${S}/files/" || die
}

src_install() {
	distutils-r1_src_install

	# Install default settings file
	insinto /etc/${PN}
	doins "${S}/files/default-settings.json"
}

pkg_postinst() {
	elog "bliss-initramfs has been installed."
	elog "To create an initramfs, run: mkinitrd.py -k \$(uname -r)"
	elog "For NVMe support, enable the nvme USE flag"
	elog "Documentation can be found at: ${HOMEPAGE}"
}