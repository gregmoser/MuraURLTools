<cfset local.data = rc.data />
<cfoutput>
	<form method="post" action="#buildUrl('urlAlias.save')#">
		<input type="hidden" name="urlAliasID" value="#val(local.data.urlAliasID)#">
		
		<cfif isdefined('rc.err') and arrayLen(rc.err) gt 0>
			<cfloop array="#rc.err#" index="i">
				<font color="red">#i#<br></font>
			</cfloop>
		</cfif>
			
		<table  class="adminTable" style="width:400px;" border="1">
			<tr>
				<td class="formLabel">Alias URL:</td>
				<td class="formField"><input type="text" name="aliasURL" value="#HtmlEditFormat(local.data.aliasURL)#"></td>
			</tr>
			<tr>
				<td class="formLabel">Redirect URL:</td>
				<td class="formField"><input type="text" name="redirectURL" value="#HtmlEditFormat(local.data.redirectURL)#"></td>
			</tr>
		</table>
		<input type="submit" value="Save Alias">
	</form>
</cfoutput>