<?xml version="1.0" encoding="UTF-8"?>
<!--
  ~ JBoss, Home of Professional Open Source.
  ~ Copyright 2011, Red Hat, Inc., and individual contributors
  ~ as indicated by the @author tags. See the copyright.txt file in the
  ~ distribution for a full listing of individual contributors.
  ~
  ~ This is free software; you can redistribute it and/or modify it
  ~ under the terms of the GNU Lesser General Public License as
  ~ published by the Free Software Foundation; either version 2.1 of
  ~ the License, or (at your option) any later version.
  ~
  ~ This software is distributed in the hope that it will be useful,
  ~ but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ Lesser General Public License for more details.
  ~
  ~ You should have received a copy of the GNU Lesser General Public
  ~ License along with this software; if not, write to the Free
  ~ Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
  ~ 02110-1301 USA, or see the FSF site: http://www.fsf.org.
  -->
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns="urn:jboss:domain:1.2"
    exclude-result-prefixes="xs xsl xsi fn xdt">
    <!--
    https://issues.jboss.org/browse/SWITCHYARD-548
    xmlns:jpa="urn:jboss:domain:jpa:1.0"
    -->

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="@xsi:schemaLocation">
    <xsl:attribute name="xsi:schemaLocation">
        <xsl:value-of select="."/>
        <xsl:text> urn:jboss:domain:switchyard switchyard.xsd</xsl:text>
    </xsl:attribute>
</xsl:template>

<xsl:template match="node()[name(.)='extensions']">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
        <extension module="org.switchyard"/>
    </xsl:copy>
</xsl:template>

<!-- http://kverlaen.blogspot.com/2011/07/jbpm5-on-as7-lightning.html -->
<!--
https://issues.jboss.org/browse/SWITCHYARD-548
<xsl:template match="node()[name(.)='extension' and @module='org.jboss.as.jpa']">
</xsl:template>
<xsl:template match="jpa:subsystem">
</xsl:template>
-->

<xsl:template match="node()[name(.)='profile']">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
        <subsystem xmlns="urn:jboss:domain:switchyard:1.0">
            <modules>
                <module identifier="org.switchyard.component.bean" implClass="org.switchyard.component.bean.deploy.BeanComponent"/>
                <module identifier="org.switchyard.component.soap" implClass="org.switchyard.component.soap.deploy.SOAPComponent">
                    <properties>
                        <socketAddr>:18001</socketAddr>
                    </properties>
                </module>
                <module identifier="org.switchyard.component.camel" implClass="org.switchyard.component.camel.deploy.CamelComponent">
                    <properties>
                        <socketAddr>:18001</socketAddr>
                    </properties>
                </module>
                <module identifier="org.switchyard.component.rules" implClass="org.switchyard.component.rules.deploy.RulesComponent"/>
                <module identifier="org.switchyard.component.bpm" implClass="org.switchyard.component.bpm.deploy.BPMComponent"/>
                <module identifier="org.switchyard.component.bpel" implClass="org.switchyard.component.bpel.deploy.BPELComponent"/>
                <module identifier="org.switchyard.component.hornetq" implClass="org.switchyard.component.hornetq.deploy.HornetQComponent"/>
            </modules>
        </subsystem>
    </xsl:copy>
</xsl:template>

<!-- http://kverlaen.blogspot.com/2011/07/jbpm5-on-as7-lightning.html
https://issues.jboss.org/browse/SWITCHYARD-548
<xsl:template match="node()[name(.)='datasources']">
    <xsl:copy>
        <datasource jndi-name="java:jboss/datasources/jbpmDS" pool-name="jbpmPool" enabled="true" jta="false" use-java-context="true" use-ccm="false">
            <connection-url>jdbc:h2:~/jbpmDS;DB_CLOSE_DELAY=-1</connection-url>
            <driver>h2</driver>
            <pool>
                <prefill>false</prefill>
                <use-strict-min>false</use-strict-min>
                <flush-strategy>FailingConnectionOnly</flush-strategy>
            </pool>
            <security>
                <user-name>sa</user-name>
                <password>sa</password>
            </security>
            <validation></validation>
            <timeout></timeout>
            <statement></statement>
        </datasource>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>
-->

<!-- http://kverlaen.blogspot.com/2011/07/jbpm5-on-as7-lightning.html 
https://issues.jboss.org/browse/SWITCHYARD-548
<xsl:template match="node()[name(.)='security-domains']">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
        <security-domain name="jbpm-console" cache-type="default">
            <authentication>
                <login-module code="UsersRoles" flag="required"/>
            </authentication>
        </security-domain>
    </xsl:copy>
</xsl:template>
-->

<xsl:template match="node()[name(.)='security-domains']">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
        <security-domain name="bpel-console" cache-type="default">
            <authentication>
                <login-module code="UsersRoles" flag="required"/>
            </authentication>
        </security-domain>
    </xsl:copy>
</xsl:template>

</xsl:stylesheet>
