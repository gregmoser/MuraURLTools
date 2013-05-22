<!--- Important: the variables.framework.base needs to be the same as the plugin/config.xml package attribute (Except package does not include "/") --->
<cfscript>
    variables.framework = {
        applicationKey = "URLAlias",
        base="/urlAlias",
        home="admin:urlAlias.list",
        action="action",
        usingsubsystems=true,
		defaultSubsystem = 'home'
    };
</cfscript>