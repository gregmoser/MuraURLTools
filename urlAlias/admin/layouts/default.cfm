<cfscript>
if(request.pluginConfig.getSetting("pluginMode")  eq "Admin"){
	writeoutput(layout("admin",body));
} else {
	writeoutput(layout("plugin",body));
}
</cfscript>