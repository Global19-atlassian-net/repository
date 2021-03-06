<?xml version="1.0" encoding='UTF-8'?>
 
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:reg="http://dublincore.org/Registry#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcq="http://purl.org/dc/terms/"
  xmlns:java="java" 
	exclude-result-prefixes="java rdf rdfs reg dc dcq">

<xsl:output method="html" indent="yes" encoding="UTF-8"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" />


<xsl:include href="banner.xsl"/>
<xsl:include href="footer.xsl"/>
<xsl:include href="_url_encode.xsl"/>

<xsl:include href="admin-common.xsl"/>

<xsl:param name="reqType" select="' '"/>
<xsl:param name="uiStyle" select="'std'"/>
<xsl:param name="uiLang" select="'en_US'"/>
<xsl:param name="resultsLang" select="'en_US'"/>
<xsl:param name="location" select="'administration'"/>

<xsl:variable name="rdf" select="'http://www.w3.org/1999/02/22-rdf-syntax-ns#'" />
<xsl:variable name="rdfs" select="'http://www.w3.org/2000/01/rdf-schema#'"/>
<xsl:variable name="service" select="'/dcregistry/propertyEditorServlet'"/>

<xsl:variable name="bundle">
    <xsl:choose>
	<xsl:when test="$uiStyle='rdf'">
	    <xsl:value-of select="'rdf'"/>
	</xsl:when>
	<xsl:otherwise>
	    <xsl:value-of select="'labels'"/>
	</xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<xsl:variable name="locale" select="java:util.Locale.new(substring($uiLang,1,2), substring($uiLang,4,2))"/>
<xsl:variable name="resources" select="java:util.ResourceBundle.getBundle('ui', $locale)"/>
<xsl:variable name="label_names" select="java:util.ResourceBundle.getBundle($bundle, $locale)"/>

<xsl:template match="/">
    <html>
	<head>
	    <title>The Open Metadata Registry</title>
	    <link type="text/css" rel="stylesheet" href="/dcregistry/css/default.css" />
	    <script type="text/javascript" src="select_lang.js"/>
	</head>	
	<body>

	<xsl:call-template name="banner">		
		<xsl:with-param name="action" select="$location" />
	</xsl:call-template>

	<p/>

	<h1>Property Editor</h1>

	<p/>

	<xsl:choose>
	    <xsl:when test="rdf:RDF/rdf:Description">
		<xsl:apply-templates select="rdf:RDF/rdf:Description[@rdf:about]"/>

		[<a href="{$service}">Select File</a>]
		[<a href="/dcregistry/adminServlet">Back to Top Page</a>]
	    </xsl:when>
	    <xsl:otherwise>
		<table cellspacing="0" class="border">
		<form action="{$service}" method="post" enctype="multipart/form-data">
		<tr><th>File name</th>
		<td><input name="filedata" type="file" size="50"/></td>
		</tr>
		<tr><th>&#160;</th>
		<td><input type="submit" value="Submit"/>&#160;&#160;<input type="reset" /></td>
		</tr>
		</form>
		</table>
		<p/>
		[<a href="/dcregistry/adminServlet">Back to Top Page</a>]
	    </xsl:otherwise>
	</xsl:choose>

	<xsl:call-template name="footer"/>

	</body>
    </html>
</xsl:template>

<xsl:template match="rdf:Description[@rdf:about='http://dublincore.org/Registry#before']">
    <form action="{$service}" method="post">
	<input type="hidden" name="function" value="create" />
	<table cellspacing="0" class="border">
	    <tr>
		<th>Property Name</th>
		<th>New Value</th>
		<th>Original Value</th>
	    </tr>
	    <xsl:for-each select="reg:element/@rdf:nodeID">
		<xsl:variable name="target" select="/rdf:RDF/rdf:Description[@rdf:nodeID=current()]"/>
		<tr>
		<!--
		    <td>
			<input type="text" name="pname" size="40">
			    <xsl:attribute name="value">
				<xsl:value-of disable-output-escaping="yes" select="$target/reg:name"/>
			    </xsl:attribute>
			</input>
		    </td>
		    -->
		    
		    <td>
			<xsl:value-of disable-output-escaping="yes" select="$target/reg:name"/>
		    </td>
		    
		    <td>
			<xsl:text disable-output-escaping="yes">&lt;</xsl:text>input type="text" name="newval" size="40" value="<xsl:value-of disable-output-escaping="yes" select="$target/reg:value"/>" <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			<!-- 
			<input type="text" name="newval" size="40">
			    <xsl:attribute name="value">
				<xsl:value-of disable-output-escaping="yes" select="$target/reg:value"/>
			    </xsl:attribute>
			</input>
			-->
		    </td>
		    <td>
		   	<!--
			<xsl:value-of disable-output-escaping="yes" select="concat($target/reg:name, ' = ', $target/reg:value)"/>
			-->
			<xsl:value-of disable-output-escaping="yes" select="$target/reg:value"/>
		    </td>
		</tr>
	    </xsl:for-each>
	
	<tr><td colspan="3">
	<input type="checkbox" name="asfile" value="true" /> Save results to local disk.
	&#160;&#160;
	<input type="submit" value="Submit"/>&#160;&#160;<input type="reset" />
	 </td></tr>
	</table>
    </form>
</xsl:template>

<xsl:template match="rdf:Description[@rdf:about='http://dublincore.org/Registry#after']">
    <h4>Results :</h4>
    <pre>
    <xsl:for-each select="reg:element/@rdf:nodeID">
	<xsl:variable name="target" select="/rdf:RDF/rdf:Description[@rdf:nodeID=current()]"/>
	<xsl:value-of disable-output-escaping="yes" select="concat($target/reg:name, ' = ', $target/reg:value)"/><xsl:text>
</xsl:text>
    </xsl:for-each>
    </pre>
</xsl:template>

</xsl:stylesheet>
