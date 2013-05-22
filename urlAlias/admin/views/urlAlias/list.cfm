<cfoutput><h3>URL Alias List</h3></cfoutput>
<cfset maxrows = "50" />
<cfset urlAlias = rc.data />
<cfset urlAliasArray = [] />
<cfif urlAlias.recordcount eq 0>
	<cfoutput>No URL Alias Found</cfoutput>
<cfelse>
	<table class="adminTable" border="1">
		<tr>
			<td class="formHeader"><b>&nbsp;</b></td>
			<td class="formHeader"><b>Alias URL</b></td>
			<td class="formHeader"><b>Redirect URL</b></td>
			<td class="formHeader"><b>Status</b></td>
			<td class="formHeader"><b>&nbsp;</b></td>
		</tr>
		<cfoutput query="urlAlias" maxrows="#maxrows#" startrow="#rc.startAt#">
			<cfset arrayAppend(urlAliasArray,{url=urlAlias.aliasURL,id=urlAlias.urlAliasID}) />
			<tr>
				<td width="30">
					<a href="#buildUrl('urlAlias.edit&urlAliasID=#urlAlias.urlAliasID#')#">[Edit]</a>
				</td>
				<td class="formField">#urlAlias.aliasURL#</td>
				<td class="formField">#urlAlias.redirectURL#</td>
				<td class="formField"><div id="status_#urlAliasID#"></div></td>
				<td width="30">
					<a class="delete" href="#buildUrl('urlAlias.delete&urlAliasID=#urlAlias.urlAliasID#')#">[Delete]</a>
				</td>
			</tr>
		</cfoutput>
	</table>
	<!--- PAGING --->
	<div>
	<cfif urlAlias.recordcount GT 30>
	<cfoutput>
		<cfset counter = 0>
		Page: 
		<cfloop from="1" to="#urlAlias.recordcount#" index="i" step="#maxrows#">
			<cfset counter = counter +1>
			<a href="#buildURL('urlAlias.list&startAt=#i#')#">
				<cfif i EQ rc.startAt><b></cfif>
				#counter#
				<cfif i EQ rc.startAt></b></cfif>
			</a>&nbsp;
		</cfloop>
	</cfoutput>
	</cfif>
	<cfoutput><div style="float:right;">Total: #urlAlias.recordcount#</div></cfoutput>
	</div>
	<!--- PAGING --->
</cfif>
<cfoutput>
	<p>&nbsp;</p>
	<a href="#buildUrl('urlAlias.edit&urlAliasID=0')#" title="Add URL Alias">+ Add URL Alias</a>&nbsp;|&nbsp;
	<a href="##" id="checkLinks" title="Add URL Alias">> Test Links</a>
</cfoutput>
<script>
$(document).ready(function() {
	$("a.delete").click(function() {
		return confirm("Are you sure you want to delete this?")
	});
	$('a#checkLinks').click(function(){
		<cfoutput>#toScript(variables.urlAliasArray,"urlAliasArray",false)#</cfoutput>
		$.each(urlAliasArray,function(index){
			var rowIndex = index+1;
			var status = '';
			$('div#status_'+urlAliasArray[index].id).html('<p align="center"><img src="assets/images/ajax-loader.gif" width="16" height="16" /></p>');
			var urlToTest = urlAliasArray[index].url ;
			if (urlToTest.indexOf('http') == -1 && urlToTest.charAt(0) == '/') {
				urlToTest = 'http://' + document.domain + urlToTest;
			} else if(urlToTest.indexOf('http') == -1){
				urlToTest = 'http://' + document.domain + '/' + urlToTest ;
			}
			var http = new XMLHttpRequest();
			http.open('HEAD', 'assets/checkLinks.cfm?link='+urlToTest, false);
			http.send();
			if(http.status == 200){
				status = 'pass';
			} else {
				status = 'fail: ' + http.status;
			}
			$('div#status_'+urlAliasArray[index].id).html(status);
		});
	});
})
</script>
