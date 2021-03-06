# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A pure Java Subversion client library"
HOMEPAGE="http://svnkit.com/"
SRC_URI="http://www.svnkit.com/org.tmatesoft.svn_${PV}.src.zip"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="tmate"
IUSE=""

COMMON_DEPEND="
	dev-java/ganymed-ssh2
	dev-java/sequence
	>=dev-util/subversion-1.4"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEPEND}"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"

S="${WORKDIR}/${PN}-src-${PV}"

pkg_setup() {
	java-pkg-2_pkg_setup
	if ! built_with_use dev-util/subversion java; then
		msg="${CATEGORY}/${P} needs dev-util/subversion built with the java"
		msg="${msg} use flag"
		error ${msg}
		die ${msg}
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch ${FILESDIR}/${P}-build.xml.patch
	rm -vr contrib/* || die
	cd contrib || die
	java-pkg_jar-from ganymed-ssh2
	java-pkg_jar-from sequence
	java-pkg_jar-from subversion
}

EANT_BUILD_TARGET="build-library build-cli"
EANT_DOC_TARGET="build-doc"

src_install() {
	cd build/lib
	java-pkg_dojar *.jar
	dodoc *.txt || die

	cd "${S}"
	use doc && java-pkg_dojavadoc build/doc/javadoc
	use source && java-pkg_dosource svnkit/src/*
}
