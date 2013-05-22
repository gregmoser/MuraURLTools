<cfcomponent displayname="URLAliasController" output="false">
	
	<cfset variables.fw = "">
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="fw">
		<cfset variables.fw = arguments.fw>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="endlist" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">
		<cfparam name="rc.startAt" default="1">
	</cffunction>
	
	<cffunction name="save" access="public" output="false" returntype="void">
		<cfargument name="rc" type="struct" required="true">
		
		<cfset rc.err = []>
		<cfset var urlAlias = {} />
		<cfset urlAlias.urlAliasID = rc.urlAliasID>
		<cfset urlAlias.aliasURL = rc.aliasURL>
		<cfset urlAlias.redirectURL = rc.redirectURL>
		
		
		<cfif trim(urlAlias.aliasURL) eq "">
			<cfset arrayAppend(rc.err, "Please enter a <b>Alias URL</b>.")>
		</cfif>
		<cfif trim(urlAlias.redirectURL) eq "">
			<cfset arrayAppend(rc.err, "Please enter a <b>Redirect URL</b>.")>
		</cfif>
		
		<cfset rc.urlAlias = urlAlias>
		
		<cfif arrayLen(rc.err) gt 0>
			<cfset variables.fw.redirect("urlAlias.edit", "urlAliasID,urlAlias,err")>
		</cfif>
	
	</cffunction>	
	
	<cffunction name="endSave" access="public" output="false" returntype="void">
		<cfset variables.fw.redirect("urlAlias.list", "all" )>
	</cffunction>

	<cffunction name="endDelete" access="public" output="false" returntype="void">
		<cfset variables.fw.redirect("urlAlias.list", "all" )>
	</cffunction>

</cfcomponent>