<cfcomponent extends="mura.plugin.pluginGenericEventHandler">
	
	<!--- Include FW/1 configuration that is shared between then adapter and the application. --->
	<cfinclude template="frameworkConfig.cfm">
	
	<cffunction name="doEvent">
		<cfargument name="Event">
		<cfargument name="action" type="string" required="false" default="" hint="Optional: If not passed it looks into the event for a defined action, else it uses the default"/>
		
		<cfset var result = "" />
		<cfset var savedEvent = "" />
		<cfset var savedAction = "" />
		<cfset var fw1 = createObject("component","#pluginConfig.getPackage()#.Application") />
		
		<cfset request.pluginConfig=pluginConfig>
		<!--- Create a Mura struct in the url scope to pass stuff to FW/1 --->
		<cfset url.Mura = StructNew() />
		<!--- Put the current path into the url struct, to be used by FW/1 --->
		<cfset url.Mura.currentPath = CGI.SCRIPT_NAME & "/" & request.currentFilename & "/" />
		<!--- Put the event url struct, to be used by FW/1 --->
		<cfset url.Mura.event = arguments.event />
		
		
		<cfif not len( arguments.action )>
			<cfif len(arguments.event.getValue(variables.framework.action))>
				<cfset arguments.action=arguments.event.getValue(variables.framework.action)>
			<cfelse>
				<cfset arguments.action=variables.framework.home>
			</cfif>
		</cfif>
		
		<!--- put the action passed into the url scope, saving any pre-existing value --->
		<cfif StructKeyExists(request, variables.framework.action)>
			<cfset savedEvent = request[variables.framework.action] />
		</cfif>
		<cfif StructKeyExists(url,variables.framework.action)>
			<cfset savedAction = url[variables.framework.action] />
		</cfif>
		<cfset url[variables.framework.action] = arguments.action />
		
		
		<!--- call the frameworks onRequestStart --->
		<cfset fw1.onRequestStart(CGI.SCRIPT_NAME) />
		
		<!--- call the frameworks onRequest --->
		<!--- we save the results via cfsavecontent so we can display it in mura --->
		<cfsavecontent variable="result">
			<cfset fw1.onRequest(CGI.SCRIPT_NAME) />
		</cfsavecontent>
		
		<!--- restore the url scope --->
		<cfif structKeyExists(url,variables.framework.action)>
			<cfset structDelete(url,variables.framework.action) />
		</cfif>
		<!--- if there was a passed in action via the url then restore it --->
		<cfif Len(savedAction)>
			<cfset url[variables.framework.action] = savedAction />
		</cfif>
		<!--- if there was a passed in request event then restore it --->
		<cfif Len(savedEvent)>
			<cfset request[variables.framework.action] = savedEvent />
		</cfif>
		<!--- remove the content from the request scope --->
		<!--- at this point if anything needed to be stored it should have been done so by pushing stored elements into the mura event for later use --->
		<cfif structKeyExists(request, "context")>
			<cfset structDelete( request, "context" )>
		</cfif>
		<cfset structDelete( request, "pluginConfig" )>
		<!--- return the result --->
		<cfreturn result>
		
	</cffunction>

	<!--- this is the plugin hook in for mura --->

	<cffunction name="onSiteRequestStart">
        <cfargument name="Event">
        <!--- check for the redirect on paths with extension --->
		<cfif find(".",listLast(cgi.path_info,"/")) AND findNoCase("index.cfm",cgi.path_info) EQ 0>
			<cfset handleRedirect(cgi.path_info) />
		</cfif>
        <!--- put the plugin into the event --->
        <cfset event[variables.framework.applicationKey]= this />
        
    </cffunction>

	<cffunction name="onApplicationLoad">
		<cfargument name="Event">
		
		<cfset var result = "" />
		
		<!--- invoke onApplicationStart in the application.cfc so the framework can do its thing --->
		<cfinvoke component="#pluginConfig.getPackage()#.Application" method="onApplicationStart" />
		
		<cfset variables.pluginConfig.addEventHandler(this)>
	</cffunction>
	
	<cffunction name="onGlobalSessionStart">
		<cfargument name="Event">

		<!--- invoke onApplicationStart in the application.cfc so the framework can do its thing --->
		<cfinvoke component="#pluginConfig.getPackage()#.Application" method="onSessionStart" />
		
	</cffunction>
	
	<cffunction name="renderApp" output="false">
		<cfargument name="event">
		<cfreturn doEvent(arguments.event)>
	</cffunction>
	
	<!--- lookup URL alias in case of 404 --->
	<cffunction name="onSite404" output="false">
		<cfargument name="$">
		
		<cfset var missingFileName=$.event("currentFilename")>
		<cfset handleRedirect(missingFileName) />
	</cffunction>
	
	<cffunction name="handleRedirect" output="false">
		<cfargument name="missingFileName">
		
		<cfset var URLAliasService = createObject("#pluginConfig.getPackage()#.admin.services.URLAlias") />
		<cfset var redirectURL = "" />
		<cfif len(cgi.QUERY_STRING)>
			<cfset var fullURL = missingFileName & "?#cgi.QUERY_STRING#" />
		<cfelse>
			<cfset var fullURL = missingFileName />
		</cfif>
		<!--- lookup with query string --->
		<cfif cgi.QUERY_STRING NEQ "">
			<cfset redirectURL = URLAliasService.findAlias(fullURL) />
		</cfif>
		<!--- lookup without query string --->
		<cfif redirectURL EQ "">
			<cfset redirectURL = URLAliasService.findAlias(missingFileName) />
		</cfif>
		<!--- lookup with query string in remote url field for content --->
		<cfif redirectURL EQ "" AND cgi.QUERY_STRING NEQ "">
			<cfset redirectURL = URLAliasService.findAliasByRemoteURL(fullURL) />
		</cfif>
		<!--- lookup without query string in remote url field for content --->
		<cfif redirectURL EQ "">
			<cfset redirectURL = URLAliasService.findAliasByRemoteURL(missingFileName) />
		</cfif>
		<cfif redirectURL NEQ "">
			<cfset redirectURL = ReplaceNoCase(redirectURL,'{query_string}','?#cgi.query_string#') />
			<cfif left(redirectURL,4) NEQ "http" AND left(redirectURL,1) NEQ "/">
				<cfset redirectURL = "/" & redirectURL />
			</cfif>
			<cflocation url="#redirectURL#" addtoken="false" statuscode="301" />
		</cfif>
	</cffunction>

</cfcomponent>