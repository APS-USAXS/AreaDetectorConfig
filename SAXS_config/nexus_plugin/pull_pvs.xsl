<?xml version="1.0" encoding="UTF-8"?>

<!--
########### SVN repository information ###################
# $Date: 2015-02-20 10:56:46 -0600 (Fri, 20 Feb 2015) $
# $Author: jemian $
# $Revision: 7995 $
# $HeadURL: https://subversion.xray.aps.anl.gov/bcdaioc/9idc_AD/area_detector/SAXS_config/nexus_plugin/pull_pvs.xsl $
# $Id: pull_pvs.xsl 7995 2015-02-20 16:56:46Z jemian $
########### SVN repository information ###################
-->

<!-- usage:
   xsltproc -o ./pvs.xml ./pull_pvs.xsl ./nexus_attributes.xml
   
   purpose:
   Use this stylesheet to extract any and all  EPICS_PV declarations 
   in an areaDetector attributes.xml file and format them for addition
   to an areaDetector NeXus templates file as an NXcollection.
 -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">
		<xsl:apply-templates select="Attributes"/>
	</xsl:template>
	
	<xsl:template match="Attributes">
		<xsl:element name="NXcollection">	<!-- <NXcollection name="metadata" ... -->
			<xsl:attribute name="name">15ID-D_metadata</xsl:attribute>
			<xsl:attribute name="type">UserGroup</xsl:attribute>
			<xsl:comment> !!! type="UserGroup" will not be needed in AD1.7 !!! </xsl:comment>
			<!-- 
			<xsl:element name="beamline">
				<xsl:attribute name="type">CONST</xsl:attribute>
				<xsl:attribute name="outtype">NX_CHAR</xsl:attribute
					>APS 15ID-D XSD/USAXS</xsl:element> -->
			<xsl:apply-templates select="Attribute"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="Attribute">
		<xsl:if test="@type='EPICS_PV'">
			<xsl:element name="{@name}">
				<xsl:attribute name="source">
					<xsl:value-of select="@name"/>
				</xsl:attribute>
				<xsl:attribute name="type">ND_ATTR</xsl:attribute>
				<xsl:element name="Attr">
					<!-- the "pv" attribute will appear in the NeXus/HDF5 data file -->
					<xsl:attribute name="name">pv</xsl:attribute>
					<xsl:attribute name="type">CONST</xsl:attribute>
					<!-- <xsl:attribute name="outtype">NX_CHAR</xsl:attribute> -->
					<xsl:value-of select="@source"/>
				</xsl:element>
				<xsl:element name="Attr">
					<!-- the "description" attribute will appear in the NeXus/HDF5 data file -->
					<xsl:attribute name="name">description</xsl:attribute>
					<xsl:attribute name="type">CONST</xsl:attribute>
					<!-- <xsl:attribute name="outtype">NX_CHAR</xsl:attribute> -->
					<xsl:value-of select="@description"/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
