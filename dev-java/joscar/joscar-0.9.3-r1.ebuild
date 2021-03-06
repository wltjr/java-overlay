# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/joscar/joscar-0.9.3.ebuild,v 1.9 2006/10/05 17:48:40 gustavoz Exp $

inherit java-pkg-2

DESCRIPTION="A Java library for AIM's OSCAR protocol"
SRC_URI="mirror://sourceforge/joustim/joscar-${PV}-src.tar.bz2"
HOMEPAGE="http://joust.kano.net/joscar"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

DEPEND=">=virtual/jdk-1.4
	>=dev-java/ant-core-1.5"
RDEPEND=">=virtual/jre-1.4"

EANT_BUILD_TARGET="jar"
EANT_DOC_TARGET="javadoc"

src_install() {
	java-pkg_newjar ${P}-bin.jar ${PN}.jar
	dodoc USING CHANGELOG UPDATING README RELNOTES
	use doc && java-pkg_dojavadoc docs/api
}
