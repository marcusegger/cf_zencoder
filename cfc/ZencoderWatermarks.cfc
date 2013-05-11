<!---/**********************************************
 * cf_zencoder Copyright (C) 2013 Marcus Egger
 * Based on the http://zencoder.riaforge.org/ Project by SCTM Enterprises, LLC (Todd Schlomer)
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
 * Author:	Marcus Egger
 * Date:	May 8, 2013
 **********************************************/
  * This is the Zencoder watermark component for the output object.
 */--->
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