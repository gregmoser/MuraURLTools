<cfset arguments.exception = request.exception />
<cfif application.configBean.getDebuggingEnabled()>
    <cfdump var="#arguments.exception#" />
<cfelse>
    <cfinclude template="/config/custom/error.cfm" />
</cfif>
