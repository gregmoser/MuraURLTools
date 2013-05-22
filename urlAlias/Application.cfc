<cfcomponent extends="framework">
	
<cfinclude template="../../config/applicationSettings.cfm">
<cfinclude template="../../config/mappings.cfm">
<cfinclude template="../mappings.cfm">
<cfinclude template="frameworkConfig.cfm">

<cffunction name="setupRequest" output="false">
	<cfif not structKeyExists(request,"pluginConfig")>
		<cfinclude template="../../config/settings.cfm">
		<cfinclude template="plugin/config.cfm" />
	</cfif>
	
</cffunction>

</cfcomponent>