<cfcomponent output="false" extends="mura.plugin.plugincfc">

	<cffunction name="install" returntype="void" access="public" output="false">
		<cfset createTable() />
		<cfset application.appInitialized=false>
	</cffunction>

	<cffunction name="update" returntype="void" access="public" output="false">
		<cfset application.appInitialized=false>
	</cffunction>

	<cffunction name="createTable" returntype="void" access="private" output="false">
		<cftry>
			<cfquery name="urlAlias_create" datasource="#application.configbean.getdatasource()#">
				CREATE TABLE urlAlias (
				urlAliasID INT IDENTITY(1,1) NOT NULL CONSTRAINT [PK_urlAlias] PRIMARY KEY,
				aliasURL VARCHAR (500) NOT NULL ,
				redirectURL VARCHAR (500) NOT NULL
				)
			</cfquery>
			<cfcatch></cfcatch>
		</cftry>
	</cffunction>

</cfcomponent>
