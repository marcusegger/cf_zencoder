<!---/**********************************************
 * ColdFusion Zencoder API
 * Copyright (C) 2010 SCTM Enterprises, LLC (Todd Schlomer)
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **********************************************
 * Author:	Todd Schlomer
 * Date:	December 8, 2010
 **********************************************/

/**
 * This is the API for the Zencoder media encoding service (www.Zencoder.com).  See http://zencoder.com/docs/api/ for more information.
 * @author Todd Schlomer
 */--->
<cfcomponent displayname="Zencoder" extends="ZencoderHelpers" hint="This is the API for the Zencoder media encoding service (www.zencoder.com)." output="false">
	<cfproperty name="api_key" type="string" hint="This is the API key provided by Zencoder." />
	<cfproperty name="api_base_url" type="string" hint="This is the API Base URL for the Zencoder API." />
	<cfproperty name="download_connections" type="numeric" hint="You can specify the number of connections to use to download a file. This may speed up download transfer times. Be aware that more connections can place a heavier load on the server. By default, Zencoder uses 5 connections. The maximum allowed is 25." />
	<cfproperty name="passThroughPhrase" type="string" hint="Optional information to store alongside this job." />
	<cfproperty name="region" type="string" hint="You can specify an Amazon AWS region to use for encoding a job and we will process the job on servers in the region specified." />
	<cfproperty name="api_timeout" type="numeric" hint="This is the API timeout time in seconds." />
	<cfproperty name="testMode" type="boolean" hint="If true, test mode will be enabled for the API." />
	<cfproperty name="strictMode" type="boolean" hint="By default, Zencoder will try to correct encoding problems for you. This is called compatible mode. If you don't want that set strictMode to false" />
	<cfproperty name="privateMode" type="boolean" hint="Privacy mode will enforce certain API parameters to protect your content from unauthorized views and obfuscate any potentially sensitive information. Zencoder employees will not view private files for any reason." />

	<!--- init --->
	<cffunction name="init" access="public" returntype="Zencoder" output="false">
			<cfargument name="api_key" type="string" required="yes" hint="This is the API key provided by Zencoder.">
			<cfargument name="api_base_url" type="string" required="no" default="https://app.zencoder.com/api/v2"  hint="This is the API Base URL for the Zencoder API.">
			<cfargument name="download_connections" type="numeric" required="no" default="0" hint="If set to zero, it will use the Zencoder default of 5.  The maximum allowed is 25.">
			<cfargument name="passThroughPhrase" type="string" required="yes" default="" hint="Optional information to store alongside this job.">
			<cfargument name="region" type="string" required="no" default="europe" hint="VALID VALUES: us, europe, asia, sa, australia, us-n-virginia, us-oregon, us-n-california, eu-dublin, asia-singapore, asia-tokyo, sa-saopaulo, or australia-sydney">
			<cfargument name="api_timeout" type="numeric" required="no" default="10" hint="This is the API timeout time in seconds.">
			<cfargument name="testMode" type="boolean" required="no" default="false" hint="If true, test mode will be enabled for the API.">
			<cfargument name="strictMode" type="boolean" required="no" default="false" hint="If true, sctrict mode will be enabled for the API.">
			<cfargument name="privateMode" type="boolean" required="no" default="false" hint="If true, private mode will be enabled for the API.">
			
			<cfscript>
				variables.api_key = arguments.api_key;
				variables.api_base_url = arguments.api_base_url;
				variables.download_connections = arguments.download_connections;
				variables.region = arguments.region;
				variables.api_timeout = arguments.api_timeout;
				variables.testMode = arguments.testMode;
				variables.strictMode = arguments.strictMode;
				variables.privateMode = arguments.privateMode;
				variables.pass_through = arguments.passThroughPhrase;
				// check parameters
				if (len(trim(variables.api_key)) == 0) {
					throw(type = "InvalidParameter", message = "The api_key parameter is not defined.");
				}
				if (len(trim(variables.api_base_url)) == 0) {
					throw(type = "InvalidParameter", message = "The api_base_url parameter is not defined.");
				}
				if ((variables.download_connections < 0) or (variables.download_connections > 25)) {
					throw(type = "InvalidParameter", message = "The download_connections parameter must be within [0,25].");
				}
				if (len(trim(variables.region)) == 0) {
					throw(type = "InvalidParameter", message = "The region parameter is not defined.");
				}
				return this;
			</cfscript>
	</cffunction>
	
	<!--- createEncodingJob --->
	<cffunction name="createEncodingJob" access="public" returntype="struct" output="false" hint="This will create a transcoding job at Zencoder.">
			<cfargument name="input" type="string" required="yes" hint="This is the address of the media input (HTTP, HTTPS, FTP, or SFTP URL).">
			<cfargument name="download_connections" type="numeric" required="no" default="0" hint="If set to zero, it will use the default value.">
			<cfargument name="passThroughPhrase" type="string" required="yes" default="" hint="Any string up to 255 characters, optional information to store alongside this job.">
			<cfargument name="output" type="ZencoderOutputArray" required="yes" hint="This is the array of job outputs.">
			
			<cfscript>
				// use the default download connections if the given one isn't used
				if ((arguments.download_connections < 1) or (arguments.download_connections > 25)) {
					arguments.download_connections = variables.download_connections;
				}
				// build the input values
				var jobInput = structNew();
				jobInput.api_key = variables.api_key;
				jobInput.region = variables.region;
				if (len(trim(variables.pass_through))) {
					jobInput.pass_through = variables.pass_through;
				}
				jobInput.download_connections = arguments.download_connections;		
				jobInput.input = arguments.input;

				jobInput.output = arguments.output.getData();
				if (variables.testMode) {
					jobInput.test = 1;
				}
				if (variables.strictMode) {
					jobInput.strict = 1;
				}
				if (variables.privateMode) {
					jobInput.private = 1;
				}											
				
				// perform the API call
				var result = performApiCall(apiMethodPath = "jobs",httpMethod = "post",methodBody = jobInput);
				result.outputs = arrayNew(1);
				if (result.success and isDefined("result.data.id")) {
					result.jobID = result.data.id;
					
					// build the output array to contain the outputID and label (don't include the URL incase there is sensitive information)
					if (isDefined("result.data.outputs") and isArray(result.data.outputs)) {
						var i = 1;
						for (; i <= arrayLen(result.data.outputs); i++) {
							arrayAppend(result.outputs, structNew());
							try {
								result.outputs[i].id 	= result.data.outputs[i].id;
								result.outputs[i].label = result.data.outputs[i].label;
							} catch (Any e) {
								result.message &= "; Output Build Error [" & i & "]: " & e.message;
								result.outputs[i].id 	= 0;
								result.outputs[i].label = "UNKNOWN";
							}
						}
					}
					
				} else {
					result.jobID = 0;
				}
				return result;
		</cfscript>
	</cffunction>
	
	<!--- getJobDetails --->
	<cffunction name="getJobDetails" access="public" returntype="struct" output="false" hint="This will get the details for a transcoding job at Zencoder.">
			<cfargument name="jobID" type="numeric" required="yes" hint="This is the job ID from Zencoder to get the details for.">
			
			<cfscript>
				// perform the API call
				var result = performApiCall(apiMethodPath = "jobs/" & jobID);
				return result;
			</cfscript>
	</cffunction>
	
	<!--- getJobProgress --->
	<cffunction name="getJobProgress" access="public" returntype="struct" output="false" hint="This will get the progress for a transcoding job at Zencoder.">
			<cfargument name="outputID" type="numeric" required="yes" hint="This is the job ID from Zencoder to get the details for.">
			
			<cfscript>
				// perform the API call
				var result = performApiCall(apiMethodPath 	= "outputs/" & outputID & "/progress");
				return result;
			</cfscript>
	</cffunction>
	
	<!--- getOutputDetails --->
	<cffunction name="getOutputDetails" access="public" returntype="struct" output="false" hint="This will get the output details for a transcoded Zencoder job (available in API version 2 or greater).">
			<cfargument name="outputID" type="numeric" required="yes" hint="This is the output ID from Zencoder to get the details for.">
			
			<cfscript>
				// perform the API call
				var result = performApiCall(apiMethodPath 	= "outputs/" & outputID);
				return result;
			</cfscript>
	</cffunction>	

	<!--- buildMediaDetailsFromJobCreation --->
	<cffunction name="buildMediaDetailsFromJobCreation" access="public" returntype="struct" output="false" hint="This is a helper method to build the media details from the job creation result.">
			<cfargument name="jobID" type="numeric" required="true" hint="This is the job ID from Zencoder to build the details for.">
			<cfargument name="outputs" type="array" required="true" hint="This is the outputs from Zencoder that were created">
			
				<cfscript>
					var i = 1;
					var mediaDetails 	= structNew();
					var jobDetails 		= structNew();
					
					// setup the job details
					jobDetails.id		 		= jobID;
					jobDetails.state 			= "processing";
					jobDetails.progress 		= 0;
					jobDetails.outputs 			= structNew();
					jobDetails.totalOutputs 	= arrayLen(outputs);
					jobDetails.outputsCompleted	= 0;
					jobDetails.outputsFailed	= 0;
					
					// loop to add all the outputs
					for (; i <= jobDetails.totalOutputs; i++) {
						var output = structNew();
						output.id		 	= outputs[i].id;
						output.label	 	= outputs[i].label;
						output.state 		= "processing";
						output.progress 	= 0;
						output.message 		= "";
						output.errorLink	= "";
						structInsert(jobDetails.outputs, numberFormat(output.id, "9"), output);
					}
					structInsert(mediaDetails, numberFormat(jobID, "9"), jobDetails);
					return mediaDetails;
				</cfscript>
	</cffunction>	
	
	<!--- performApiCall --->
	<cffunction name="performApiCall" access="private" returntype="struct" output="false" hint="This will perform the API call to Zencoder.">
			<cfargument name="apiMethodPath" type="string" required="yes" hint="This is the API method call URL path.  This value should not lead with a '/'.">
			<cfargument name="httpMethod" type="string" required="no" default="get"	hint="This is the http method that will be used to perform the API call.">
			<cfargument name="methodBody" type="struct" required="no" default="#javaCast("null", 0)#" hint="This is the API method body that will be sent as a object.">
			
			<cfscript>
				var result = structNew();
				var apiPath = "#variables.api_base_url#/#apiMethodPath#";
				result.path = apiPath;		// used for debugging
				
				// if the HTTP method is 'get', attach the api_key to the URL
				if (compareNoCase(httpMethod, "get") == 0) {
					apiPath &= "?api_key=" & variables.api_key;
				}
			</cfscript>
		
		<!--- Remove the JsafeJCE security provider and add it back after done: http://forums.adobe.com/message/2312598, http://www.coldfusionjedi.com/index.cfm/2011/1/12/Diagnosing-a-CFHTTP-issue--peer-not-authenticated --->
		<cfset var providerMethods = CreateObject('java','java.security.Security') />
		<cfset var jSafeProvider = providerMethods.getProvider('JsafeJCE') />
		<cfset providerMethods.removeProvider('JsafeJCE') />
		
		<!--- perform the API call --->
		<cftry>
			<cfhttp url="#apiPath#" timeout="#variables.api_timeout#" method="#httpMethod#">
				<cfhttpparam type="header" name="Content-Type" 	value="application/json" />
				<cfhttpparam type="header" name="Accept" 		value="application/json" />
				<cfif not isNull(methodBody)>
					<!---<cfhttpparam type="Body" value="#jsonEncode(methodBody)#" />--->
					<!--- hard code a hack to rename the 'Cache-Control' header to have the correct case since Zencoder is case sensitive for the header values; contacting them to remove this restriction --->
					<cfhttpparam type="Body" value="#replaceNoCase(jsonEncode(methodBody), "Cache-Control", "Cache-Control", "all")#" />
				</cfif>
			</cfhttp>
		<cffinally>
			<!--- reinsert the jSafeProvider type --->
			<cftry>
				<cfset providerMethods.insertProviderAt(jSafeProvider, 1) />
			<cfcatch type="any">
			</cfcatch>
			</cftry>
		</cffinally>
		</cftry>
		
		<cfscript>
			if (isDefined("cfhttp.Responseheader.Status_Code") and ((cfhttp.Responseheader.Status_Code == 201) or (cfhttp.Responseheader.Status_Code == 200))) {
				result.data = jsonDecode(cfhttp.FileContent);
				result.success = true;
			} else {
				result.success = false;
				result.statusCode = cfhttp.statusCode;
				result.message = cfhttp.FileContent;
				result.cfhttp = cfhttp;
				if (not isNull(methodBody)) {
					result.body = jsonEncode(methodBody);
				}
			}
			return result;
		</cfscript>
	</cffunction>
	
</cfcomponent>