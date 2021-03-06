# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/hessian/hessian-3.0.8-r3.ebuild,v 1.2 2006/08/02 04:28:10 nichoj Exp $

inherit java-pkg-2 java-ant-2

DESCRIPTION="The Hessian binary web service protocol makes web services usable without requiring a large framework, and without learning yet another alphabet soup of protocols."
HOMEPAGE="http://www.caucho.com/hessian/"
SRC_URI="http://www.caucho.com/hessian/download/${P}-src.jar"

LICENSE="Apache-1.1"
SLOT="3.0.20"
KEYWORDS="~amd64 ~x86"
IUSE="doc source"

COMMON_DEP="=dev-java/servletapi-2.3*"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND="=virtual/jdk-1.5*
	app-arch/unzip
	source? ( app-arch/zip )
	dev-java/ant-core
	${COMMON_DEP}"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cp ${FILESDIR}/build-3.0.13.xml ${S}/build.xml \
		|| die "copy build.xml failed!"
}

src_compile() {
	eant jar $(use_doc) \
		-Dclasspath="$(java-pkg_getjars servletapi-2.3)" \
		-Dsrc="." \
		-Dproject.name="${PN}" \
		-Dbasedir="${S}"
}

src_install() {
	java-pkg_dojar dist/${PN}.jar

	use doc && java-pkg_dohtml -r dist/doc/api
	use source && java-pkg_dosrc com
}
