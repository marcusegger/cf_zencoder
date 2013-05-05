<cfcomponent displayname="ZencoderWatermarks" hint="This is the Zencoder watermark object" output="false" accessors="true">
	
	<cfproperty name="watermarkArray" type="array" 	hint="This is the array of watermarks." />
	
	<!--- init --->
	<cffunction name="init" access="public" returntype="ZencoderWatermarks" output="false" hint="Constructor method.">
		<cfscript>
			variables.watermarkArray = arrayNew(1);
			return this;
		</cfscript>
	</cffunction>
	
	<!--- addWatermark --->
	<cffunction name="addWatermark" access="public" returntype="ZencoderWatermarks" output="false" hint="This will add a watermark to the array.">
			<cfargument name="watermark" type="struct" required="yes" hint="This is a watermark object.  The definition can be obtained from the Zencoder API.">
		<cfscript>
			arrayAppend(variables.watermarkArray, arguments.watermark);
			return this;
		</cfscript>
	</cffunction>
	
	<!--- getData --->
	<cffunction name="getData" access="public" returntype="array" output="false" hint="This will build the data object that will be sent to Zencoder via the API.">
		<cfscript>
			var data = arrayNew(1);
			var i = 1;
			for (; i <= arrayLen(variables.watermarkArray); i++) {
				arrayAppend(data, variables.watermarkArray[i]);
			}
			return data;
		</cfscript>
	</cffunction>
	
</cfcomponent>