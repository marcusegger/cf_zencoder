<cfscript>
	// initial settings
	variables.sourceVideoFileName = "testvideo.mp4";
	// location of the source file
	variables.sourceFileURL 	= "http://www.example.com/encodingtests/tmp/" & variables.sourceVideoFileName;
	// location where the result should be saved
	variables.base_url 		= "ftp://johndoe:password@example.com/encodingtests/tmp";
	// email address or callback URL
	variables.notifyUrl		= "john.doe@example.com";
	// your Zencoder API key
	variables.sZencoderApiKey = "yourAPIkeyhere";
	
	// video information
	width	= 1920;
	height	= 1080;

	// import cfc directory and setup the zencoder api reference
	import "cfc.*";
	zencoderApi = new Zencoder(argumentCollection = {api_key = "#variables.sZencoderApiKey#", download_connections = 25, testMode = false, strictMode = false, region="europe", privateMode = false, passThroughPhrase="some remarks for this job", api_base_url="https://app.zencoder.com/api/v2", pass_through="some additional information for this job if you like"});
	
	// check for the video aspect ratio
	is_16x9_aspect = ((width / 16) == (height / 9));
	
	// set the keyframe (every second) rate
	keyframe_rate = 1; 
	
	// setup the zencoder notifications for the outputs
	zencoderNotification = new ZencoderNotification();
	zencoderNotification.addNotification(variables.notifyUrl);
	
	// setup the zencoder output array (this is where all the outputs will be placed)
	zencoderOutputArr = new ZencoderOutputArray();
	
	// 480p 2-pass, bitrate 1000
	zencoderOutputArr.addOutput(new ZencoderOutput(
			label 				= "480p",
			base_url 			= variables.base_url,
			filename 			= "480p_" & variables.sourceVideoFileName,
			video_bitrate		= 1000,
			size				= "854x480",
			speed				= 4,
			notifications		= zencoderNotification));		
	
	// 720p 2-pass / bitrate 2500
	zencoderOutputArr.addOutput(new ZencoderOutput(
			label 				= "720p",
			base_url 			= variables.base_url,
			filename 			= "720_" & variables.sourceVideoFileName,
			video_bitrate		= 2500,
			size				= "1280x720",
			speed				= 4,
			notifications		= zencoderNotification));		
					
	try {
		// perform the API call
		zencoderResult = zencoderApi.createEncodingJob(input = variables.sourceFileURL, output = zencoderOutputArr);
	}
	catch (any e) {
		WriteOutput("an error occured: " & e.message);
	}
	
	writeDump(variables.sourceFileURL);
	//dump(zencoderOutputArr);
	
	if (zencoderResult.success) {
		writeOutput("API-Call successfull!<br />");
		writeOutput("Details: " & variables.sourceFileURL & " will be converted to " & variables.base_url &  "<br />");
		writeOutput("Job-ID: " & zencoderResult.jobID & "<br />");
		writeOutput("Job Details:<br />");
		writeDump(zencoderApi.buildMediaDetailsFromJobCreation(jobID = zencoderResult.jobID, outputs = zencoderResult.outputs));
	} else {
		writeOutput("API-Call failed!<br />");
		writeDump(zencoderResult);
		writeOutput("Message: " & zencoderResult.message & "<br />");
	}
</cfscript>