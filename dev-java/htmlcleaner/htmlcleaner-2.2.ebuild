# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="HtmlCleaner"
JAVA_PKG_IUSE="doc source"

EAPI="2"
inherit java-pkg-2 java-ant-2

DESCRIPTION="HTML parser written in Java that can be used as a tool, library or Ant task"
HOMEPAGE="http://htmlcleaner.sourceforge.net/"
SRC_URI="mirror://sourceforge/htmlcleaner/files/${P}-all.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="dev-java/ant-core
	dev-java/jdom:1.0"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.5
	test? ( dev-java/junit:4 )"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"

S="${WORKDIR}/${MY_PN}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="ant-core,jdom-1.0"
JAR="${PN}${PV//./_}.jar"

src_prepare() {
	rm -v *.jar || die

	# Don't require default.xml to be in the current directory.
	sed -i "s:\"default\.xml\":\"${JAVA_PKG_SHAREPATH}/default.xml\":g" \
		src/main/java/org/htmlcleaner/ConfigFileTagProvider.java || die
}

src_install() {
	java-pkg_newjar "${JAR}" "${PN}.jar"
	java-pkg_register-ant-task

	insinto "${JAVA_PKG_SHAREPATH}"
	doins default.xml || die
	java-pkg_dolauncher "${PN}"

	use source && java-pkg_dosrc src/main/java/*
	use doc && java-pkg_dojavadoc doc
}

src_test() {
	local DIR="src/test/java"
	local CP="${DIR}:${JAR}:$(java-pkg_getjars junit-4,${EANT_GENTOO_CLASSPATH})"
	ejavac -classpath "${CP}" -d "${DIR}" $(find "${DIR}" -name "*.java")

	local TEST; for TEST in src/test/java/org/htmlcleaner/*Test.java; do
		TEST="${TEST#src/test/java/}"
		TEST="${TEST%.java}"
		TEST="${TEST//\//.}"
		ejunit4 -classpath "${CP}" "${TEST}"
	done
}