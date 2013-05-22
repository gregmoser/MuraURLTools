<cfcomponent displayname="urlAliasService" output="false">
	
	<cffunction name="edit" access="public" output="false" returntype="any">
		<cfargument name="urlAliasID" type="any" required="true">
		<cfquery name="urlAlias_details" datasource="#application.configbean.getdatasource()#">
			SELECT *
			FROM urlAlias
			WHERE urlAliasID = <cfqueryparam value="#arguments.urlAliasID#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn urlAlias_details />
	</cffunction>
	
	<cffunction name="list" access="public" output="false" returntype="any">
		<cfquery name="urlAlias_list" datasource="#application.configbean.getdatasource()#">
			SELECT *
			FROM urlAlias
			ORDER BY urlAliasID
		</cfquery>
		<cfreturn urlAlias_list>
	</cffunction>
	
	<cffunction name="save" access="public" output="false" returntype="void">
		<cfargument name="urlAlias" type="any" required="true">
		<cftransaction>
		<cfif val(arguments.urlAlias.urlAliasID) eq 0>
			<cfquery name="urlAlias_insert" datasource="#application.configbean.getdatasource()#">
				INSERT INTO urlAlias (aliasURL,redirectURL)
				VALUES(
					<cfqueryparam value="#arguments.urlAlias.aliasURL#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.urlAlias.redirectURL#" cfsqltype="cf_sql_varchar" />
					) 
			</cfquery>
		<cfelse>
			<cfquery name="urlAlias_upd" datasource="#application.configbean.getdatasource()#">
				UPDATE urlAlias
				SET aliasURL = <cfqueryparam value="#arguments.urlAlias.aliasURL#" cfsqltype="cf_sql_varchar" />,
					redirectURL = <cfqueryparam value="#arguments.urlAlias.redirectURL#" cfsqltype="cf_sql_varchar" />
				WHERE urlAliasID = <cfqueryparam value="#arguments.urlAlias.urlAliasID#" cfsqltype="cf_sql_integer" />
			</cfquery>
		</cfif>
		</cftransaction>
	</cffunction>

	<cffunction name="delete" access="public" output="false" returntype="void">
		<cfargument name="urlAliasID" type="any" required="true">
		<cftransaction>
			<cfquery name="urlAlias_delete" datasource="#application.configbean.getdatasource()#">
				DELETE FROM urlAlias
				WHERE urlAliasID = <cfqueryparam value="#arguments.urlAliasID#" cfsqltype="cf_sql_integer" />
			</cfquery>
		</cftransaction>
	</cffunction>

	<cffunction name="findAlias" access="public" output="false" returntype="any">
		<cfargument name="aliasURL" type="any" required="true">
		<cfquery name="urlAlias_details" datasource="#application.configbean.getdatasource()#">
			SELECT redirectURL
			FROM urlAlias
			WHERE aliasURL = <cfqueryparam value="#arguments.aliasURL#" cfsqltype="cf_sql_varchar" />
			<cfif left(aliasURL,1) EQ "/">
				OR aliasURL = <cfqueryparam value="#replace(arguments.aliasURL,'/','','one')#" cfsqltype="cf_sql_varchar" />
			<cfelse>
				OR aliasURL = <cfqueryparam value="/#arguments.aliasURL#" cfsqltype="cf_sql_varchar" />
				OR aliasURL = <cfqueryparam value="/#arguments.aliasURL#/" cfsqltype="cf_sql_varchar" />
			</cfif>
		</cfquery>
		<cfreturn urlAlias_details.redirectURL />
	</cffunction>
	
	<cffunction name="findAliasByRemoteURL" access="public" output="false" returntype="any">
		<cfargument name="aliasURL" type="any" required="true">
		<cfquery name="content_details" datasource="#application.configbean.getdatasource()#">
			SELECT filename
			FROM tcontent
			WHERE tcontent.active = 1
			AND tcontent.approved = 1
			AND (remoteURL = <cfqueryparam value="#arguments.aliasURL#" cfsqltype="cf_sql_varchar" />
			<cfif left(aliasURL,1) EQ "/">
				OR remoteURL = <cfqueryparam value="#replace(arguments.aliasURL,'/','','one')#" cfsqltype="cf_sql_varchar" />
			<cfelse>
				OR remoteURL = <cfqueryparam value="/#arguments.aliasURL#" cfsqltype="cf_sql_varchar" />
				OR remoteURL = <cfqueryparam value="/#arguments.aliasURL#/" cfsqltype="cf_sql_varchar" />
			</cfif>
			)
		</cfquery>
		<cfreturn content_details.filename />
	</cffunction>
	
</cfcomponent>