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
 * This is the Zencoder output object.
 * @author Todd Schlomer
 */--->
<cfcomponent displayname="ZencoderOutput" hint="This is the Zencoder output object." output="false" accessors="true">
	
	<cfproperty name="base_url" type="string" hint="This is the base URL to export the transcoded media.  Determines a directory to put the output file in, but not the filename." />
	<cfproperty name="filename" type="string" hint="The filename of a finished file. If you supply a filename but not a base_url, Zencoder will store the file with this filename in a S3 bucket temporarily for you to download." />
	<cfproperty name="label" type="string" hint="If set to zero, it will use the Zencoder default of 5.  The maximum allowed is 25." />
	<cfproperty name="video_codec" type="string" hint="The output video codec to use." />
	<cfproperty name="speed" type="numeric" hint="A target transcoding speed, from 1 to 5." />
	<cfproperty name="width" type="numeric" hint="A width for the target media.  0 for not set." />
	<cfproperty name="height" type="numeric" hint="A height for the target media.  0 for not set." />
	<cfproperty name="aspect_mode" type="string" hint="If the aspect ratio of the input does not match the requested output aspect ratio, this specifies what the output resolution be." />
	<cfproperty name="quality" type="numeric" hint="The desired output video quality, from 1 to 5." />
	<cfproperty name="video_bitrate" type="numeric" hint="The desired output bitrate for a video, expressed in Kbps." />
	<cfproperty name="bitrate_cap" type="numeric" hint="The max peak bitrate throughout a video.  0 for not no setting." />
	<cfproperty name="buffer_size" type="numeric" hint="Used in conjunction with Max Bitrate. This number should be determined by the settings of your streaming server, or your targeted playback device. For example, Buffer Size should be set to 10000 for an iPhone. Default: 0 for none." />
	<cfproperty name="max_video_bitrate" type="string" hint="A maximum average bitrate for a movie. Overrides both the quality and video_bitrate settings to ensure that a bitrate doesn't exceed the provided number." />
	<cfproperty name="audio_codec" type="string" hint="The output audio codec to use." />
	<cfproperty name="audio_quality" type="numeric" hint="The desired output audio quality, from 1 to 5." />
	<cfproperty name="audio_bitrate" type="numeric" hint="An output bitrate setting, in Kbps. This should be a multiple of 16, and lower than 160kbps per channel (320kbps for stereo)." />
	<cfproperty name="audio_sample_rate" type="numeric" hint="Audio sample rate in Hz.  A valid sample rate. Depends on the codec; typically 8000, 11025, 12000, 16000, 22050, 32000, 44100, 48000" />
	<cfproperty name="max_frame_rate" type="numeric" hint="Rather than setting an exact frame rate, which may involve increase the frame rate (and therefore the bitrate) of some content, you can set a Max Frame Rate instead." />
	<cfproperty name="frame_rate" type="numeric" hint="The output frame rate to use, as a decimal number (e.g. 15, or 24.98). 0 for system default." />
	<cfproperty name="keyframe_interval" type="numeric" hint="Set the maximum number of frames between each keyframe. By default, a keyframe will be created at most every 250 frames. 0 to use default." />
	<cfproperty name="keyframe_rate" type="numeric" hint="Set the number of keyframes per second. So a value of 0.5 would result in one keyframe every two seconds. A value of 3 would result in three keyframes per second." />
	<cfproperty name="public" type="boolean" hint="Use the public API setting to flag a file output to S3 as being publicly readable. This is done by granting the READ permission to the AllUsers group." />
	<cfproperty name="notifications" type="ZencoderNotification" hint="This is the notification(s) to use for this output." />
	<cfproperty name="thumbnails" type="ZencoderThumbnails" hint="This is the thumbnail(s) to use for this output." />
	<cfproperty name="watermarks" type="ZencoderWatermarks" hint="This is the watermark(s) to use for this output." />
	<cfproperty name="headers" type="struct" hint="S3 supports the sending of headers with your file when it is uploaded to S3. Zencoder support setting a limited subset of the S3 headers: Cache-Control, Content-Disposition, Content-Encoding, Content-Type, Expires, x-amz-acl, x-amz-storage-class, and x-amz-meta-*." />
	<cfproperty name="size" type="string" hint="The resolution of the output video (WxH, in pixels)." />
	<cfproperty name="device_profile" type="string" hint="A device profile to use for mobile device compatibility." />
	<cfproperty name="h264_profile" type="string" hint="The H.264 profile to use." />
	<cfproperty name="h264_level" type="string" hint="The H.264 level to use." />
	<cfproperty name="h264_reference_frames" type="string" hint="A number of reference frames to use in H.264 video." />
	<cfproperty name="parallel_upload_limit" type="numeric" hint="The maximum number of simultaneous uploads made when uploading multipart outputs, primarily HLS segments. An integer between 1 and 30">
	<cfproperty name="decoder_bitrate_cap" type="numeric" hint="The max bitrate fed to the decoder via a buffer. Typically used only for streaming (RTMP or broadcast video), not for HTTP delivery of video. Only use this number if you know what you are doing. This should typically only be used for streaming (or for device playback)." />
	<cfproperty name="decoder_buffer_size" type="numeric" hint="The size of the buffer fed to the decoder when using a bitrate_cap, expressed in kbps. The buffer_size divided by bitrate_cap represents the size of the buffer in seconds; so if you set bitrate_cap to 1000 and buffer_size to 1000, the buffer is effectively 1.0 second. If bitrate_cap is 500 and buffer_size is 1000, the buffer is 2.0 seconds. This is typically used only for streaming (RTMP or broadcast video), not for HTTP delivery of video. Only use this number if you know what you are doing. This should typically only be used for streaming (or for device playback)." />
	<cfproperty name="one_pass" type="boolean" hint="By default, we will use two-pass encoding whenever encoding to a target video_bitrate, and one-pass encoding when performing constant quality encoding (which doesn't benefit from a second pass). This option will force one-pass encoding when targeting a specific video_bitrate. We highly recommend not forcing one-pass encoding. The first pass in two-pass encoding is faster than the second pass, so going from two-pass encoding to one-pass encoding only results in a 25% encoding speedup, not 50% faster encoding. And two-pass encoding looks significantly better than one-pass encoding." />
	<cfproperty name="audio_constant_bitrate" type="boolean" hint="Enable constant bitrate (CBR) mode for audio, when possible. audio_sample_rate may be adjusted for compatibility." />
	<cfproperty name="upscale" type="boolean" hint="By default, Zencoder will not increase the size of (or “upscale”) an input video to match the width and height you specify in an API request. Generally, upscaling a video just increases the size, but doesn’t really increase the quality. Your playback device (Flash, HTML5 Video, iPhone, etc.) can increase the size of a video rather than having the encoder do it. But if you do want to force Zencoder to increase the size of an input video, set “upscale” to true. If you do, an input video that is smaller than the output resolution will expand to fit the resolution. For example, if your output spec is 480×360, and someone submits a video that is 320×240, the video will be upsized to 480×360 if you set this option to true, and will remain at 320×240 otherwise." />
	<cfproperty name="aspect_mode" type="string" hint="If the aspect ratio of the input does not match the requested output aspect ratio, what should the output resolution be? aspect_mode controls this decision" />
	
	<!--- init --->
	<cffunction name="init" access="public" returntype="ZencoderOutput" output="false" hint="Constructor method.">
			<cfargument name="base_url" type="string" required="yes" hint="This is the base URL to export the transcoded media.  Determines a directory to put the output file in, but not the filename.">
			<cfargument name="filename" type="string" required="yes" hint="The filename of a finished file. If you supply a filename but not a base_url, Zencoder will store the file with this filename in a S3 bucket temporarily for you to download.">
			<cfargument name="label" type="string" required="yes" hint="If set to zero, it will use the Zencoder default of 5.  The maximum allowed is 25.">
			<cfargument name="video_codec" type="string" required="no" default="" hint="The output video codec to use.">
			<cfargument name="speed" type="numeric" required="no" default="3" hint="A target transcoding speed, from 1 to 5.">
			<cfargument name="width" type="numeric" required="no" default="0" hint="A width for the target media.  0 for not set.">
			<cfargument name="height" type="numeric" required="no" default="0" hint="A height for the target media.  0 for not set.">
			<cfargument name="aspect_mode" type="string" required="no" default="" hint="If the aspect ratio of the input does not match the requested output aspect ratio, this specifies what the output resolution be.">
			<cfargument name="quality" type="numeric" required="no" default="0" hint="The desired output video quality, from 1 to 5.">
			<cfargument name="video_bitrate" type="numeric" required="no" default="0" hint="The desired output bitrate for a video, expressed in Kbps.">
			<cfargument name="bitrate_cap" type="numeric" required="no" default="0" hint="The max peak bitrate throughout a video.  0 for not no setting.">
			<cfargument name="buffer_size" type="numeric" required="no" default="0" hint="Used in conjunction with Max Bitrate. This number should be determined by the settings of your streaming server, or your targeted playback device. For example, Buffer Size should be set to 10000 for an iPhone. Default: 0 for none.">
			<cfargument name="max_video_bitrate" type="numeric" required="no" default="0" hint="A maximum average bitrate for a movie. Overrides both the quality and video_bitrate settings to ensure that a bitrate doesn't exceed the provided number.">
			<cfargument name="audio_codec" type="string" required="no" default="" hint="The output audio codec to use.">
			<cfargument name="audio_quality" type="numeric" required="no" default="0" hint="The desired output audio quality, from 1 to 5.">
			<cfargument name="audio_bitrate" type="numeric" required="no" default="0" hint="An output bitrate setting, in Kbps. This should be a multiple of 16, and lower than 160kbps per channel (320kbps for stereo).">
			<cfargument name="audio_sample_rate" type="numeric" required="no" default="0" hint="Audio sample rate in Hz.  A valid sample rate. Depends on the codec; typically 8000, 11025, 12000, 16000, 22050, 32000, 44100, 48000">
			<cfargument name="max_frame_rate" type="numeric" required="no" default="0" hint="Rather than setting an exact frame rate, which may involve increase the frame rate (and therefore the bitrate) of some content, you can set a Max Frame Rate instead.">
			<cfargument name="frame_rate" type="numeric" required="no" default="0" hint="The output frame rate to use, as a decimal number (e.g. 15, or 24.98). 0 for system default.">
			<cfargument name="keyframe_interval" type="numeric"required="no" default="0" hint="Set the maximum number of frames between each keyframe. By default, a keyframe will be created at most every 250 frames. 0 to use default.">
			<cfargument name="keyframe_rate" type="numeric" required="no" default="0" hint="Set the number of keyframes per second. So a value of 0.5 would result in one keyframe every two seconds. A value of 3 would result in three keyframes per second.">
			<cfargument name="public" type="boolean" required="no" default="false" hint="Use the public API setting to flag a file output to S3 as being publicly readable. This is done by granting the READ permission to the AllUsers group.">
			<cfargument name="notifications" type="ZencoderNotification" required="no" default="#javaCast("null", 0)#" hint="This is the notification(s) to use for this output.">
			<cfargument name="thumbnails" type="ZencoderThumbnails" required="no" default="#javaCast("null", 0)#" hint="This is the thumbnail(s) to use for this output.">
			<cfargument name="watermarks" type="ZencoderWatermarks" required="no" default="#javaCast("null", 0)#" hint="This is the watermark(s) to use for this output.">
			<cfargument name="headers" type="struct" required="no" default="#javaCast("null", 0)#" hint="S3 supports the sending of headers with your file when it is uploaded to S3. Zencoder support setting a limited subset of the S3 headers: Cache-Control, Content-Disposition, Content-Encoding, Content-Type, Expires, x-amz-acl, x-amz-storage-class, and x-amz-meta-*.">
			<cfargument name="size"	type="string" required="no" default="" hint="WxH, where W and H are the width and height, respectively. Both dimensions should be an integer divisible by 4.">
			<cfargument name="device_profile" type="string" required="no" default="" hint="VALID VALUES: mobile/advanced, mobile/baseline, mobile/legacy, v1/mobile/advanced, v1/mobile/baseline, v1/mobile/legacy, v2/mobile/advanced, v2/mobile/baseline, and v2/mobile/legacy">
			<cfargument name="h264_profile" type="string" required="no" default="" hint="H.264 has three commonly-used profiles: Baseline (lowest), Main, and High. Lower levels are easier to decode, but higher levels offer better compression. For example, the iPhone 3gs only supports the Baseline profile, which we use by default. The Main and High profiles are a definite step up in compression, and work fine for web playback, though be careful with HD High profile video in Flash Player, which doesn’t offer the best H.264 decoder.For the best compression quality, choose High. For playback on low-CPU machines or many mobile devices, choose Baseline.">
			<cfargument name="h264_level" type="string" required="no" default="" hint="Constrains the bitrate and macroblocks. Primarily used for device compatibility. For example, the iPhone supports H.264 Level 3, which means that a video’s decoder_bitrate_cap can’t exceed 10,000kbps. Typically, you should only change this setting if you’re targeting a specific device that requires it.">
			<cfargument name="h264_reference_frames" type="string" required="no" default="" hint="More reference frames result in slightly higher compression quality, but increased decoding complexity. In practice, going above 5 rarely has much benefit. We default to 3 as a good compromise of compression and decoding complexity. Set to auto to allow our speed setting to natually choose this number.">
			<cfargument name="parallel_upload_limit" type="numeric" required="no" default="10" hint="This may speed up transfer times, depending on the bandwidth at your remote server. Be aware that more connections can place a heavier load on the server. If you have trouble with upload timeouts, or want to prevent Zencoder from using too much bandwidth when uploading files, set this to 1.">
			<cfargument name="decoder_bitrate_cap" type="numeric" required="no" default="0" hint="The max bitrate fed to the decoder via a buffer. A positive integer. 100000 max.">
			<cfargument name="decoder_buffer_size" type="numeric" required="no" default="0" hint="Size of the decoder buffer, used in conjunction with bitrate_cap. A positive integer. 100000 max.">
			<cfargument name="one_pass" type="boolean" required="no" default="false" hint="Force one-pass encoding if set to true">
			<cfargument name="audio_constant_bitrate" type="boolean" required="no" default="false" hint="Enable constant bitrate mode for audio if possible if set to true. An audio_bitrate must be specified when using audio_constant_bitrate">
			<cfargument name="upscale" type="boolean" required="no" default="false" hint="Upscale the output if the input is smaller than the target output resolution if set to true.">
			<cfargument name="aspect_mode" type="string" required="no" default="" hint="What to do when aspect ratio of input file does not match the target width/height aspect ratio. VALID VALUES: preserve, stretch, crop, or pad. At least you have to provide width and height paramter additionally.">
			
			<cfscript>
				// set the data to the variables scope
				variables.base_url 					= arguments.base_url;
				variables.filename 					= arguments.filename;
				variables.label 					= arguments.label;
				variables.video_codec 				= arguments.video_codec;
				variables.speed 					= arguments.speed;
				variables.width 					= arguments.width;
				variables.height 					= arguments.height;
				variables.aspect_mode 				= arguments.aspect_mode;
				variables.quality 					= arguments.quality;
				variables.video_bitrate 			= arguments.video_bitrate;
				variables.bitrate_cap 				= arguments.bitrate_cap;
				variables.buffer_size 				= arguments.buffer_size;
				variables.max_video_bitrate			= arguments.max_video_bitrate;
				variables.audio_codec 				= arguments.audio_codec;
				variables.audio_quality 			= arguments.audio_quality;
				variables.audio_bitrate 			= arguments.audio_bitrate;
				variables.audio_sample_rate			= arguments.audio_sample_rate;
				variables.max_frame_rate 			= arguments.max_frame_rate;
				variables.frame_rate 				= arguments.frame_rate;
				variables.keyframe_interval 		= arguments.keyframe_interval;
				variables.keyframe_rate				= arguments.keyframe_rate;
				variables.public					= arguments.public;
				variables.size						= arguments.size;
				variables.device_profile			= arguments.device_profile;
				variables.h264_profile				= arguments.h264_profile;
				variables.h264_level				= arguments.h264_level;
				variables.h264_reference_frames		= arguments.h264_reference_frames;
				variables.parallel_upload_limit		= arguments.parallel_upload_limit;
				variables.decoder_bitrate_cap		= arguments.decoder_bitrate_cap;
				variables.decoder_buffer_size		= arguments.decoder_buffer_size;
				variables.one_pass					= arguments.one_pass;
				variables.audio_constant_bitrate	= arguments.audio_constant_bitrate;
				variables.upscale					= arguments.upscale;
				variables.aspect_mode				= arguments.aspect_mode;
				
				if (not isNull(arguments.notifications)) {
					variables.notifications 	= arguments.notifications;
				}
				if (not isNull(arguments.thumbnails)) {
					variables.thumbnails 	= arguments.thumbnails;
				}
				if (not isNull(arguments.watermarks)) {
					variables.watermarks 	= arguments.watermarks;
				}				
				if (not isNull(arguments.headers)) {
					variables.headers 	= arguments.headers;
				}

				return this;
		</cfscript>
	</cffunction>
	
	<!--- getData --->
	<cffunction name="getData" access="public" returntype="struct" output="false" hint="This will build the data object that will be sent to Zencoder via the API.">
		<cfscript>
			var data = structNew();
			data.base_url 			= variables.base_url;
			data.filename 			= variables.filename;
			data.label 				= variables.label;
			data.speed 				= variables.speed;
			
			if (len(variables.video_codec))		{data.video_codec 		= variables.video_codec;}
			if (variables.width) 				{data.width 			= variables.width;}
			if (variables.height) 				{data.height 			= variables.height;}
			if (len(variables.aspect_mode))		{data.aspect_mode 		= variables.aspect_mode;}
			
			if (variables.video_bitrate) 		{data.video_bitrate 	= variables.video_bitrate;}
			if (variables.quality) 				{data.quality 			= variables.quality;}
			if (variables.audio_bitrate)		{ data.audio_bitrate 	= variables.audio_bitrate;}
			if (variables.audio_quality) 		{data.audio_quality 	= variables.audio_quality;}

			if (variables.bitrate_cap) 			{data.bitrate_cap 		= variables.bitrate_cap;}
			if (variables.buffer_size) 			{data.buffer_size	 	= variables.buffer_size;}
			if (variables.max_video_bitrate)	{data.max_video_bitrate	= variables.max_video_bitrate;}
			if (len(variables.audio_codec))		{data.audio_codec 		= variables.audio_codec;}
			if (variables.audio_sample_rate)	{data.audio_sample_rate	= variables.audio_sample_rate;}
			if (variables.max_frame_rate) 		{data.max_frame_rate 	= variables.max_frame_rate;}
			if (variables.frame_rate) 			{data.frame_rate 		= variables.frame_rate;}
			if (variables.keyframe_interval) 	{data.keyframe_interval	= variables.keyframe_interval;}
			if (variables.keyframe_rate) 		{data.keyframe_rate		= variables.keyframe_rate;}
			if (variables.public) 				{data.public			= variables.public;}
			
			if (len(variables.size))			{data.size	= variables.size;}
			if (len(variables.device_profile))	{data.device_profile	= variables.device_profile;}
			if (len(variables.h264_profile))	{data.h264_profile	= variables.h264_profile;}
			if (len(variables.h264_level))		{data.h264_level	= variables.h264_level;}
			if (len(variables.h264_reference_frames))		{data.h264_reference_frames	= variables.h264_reference_frames;}	
			if (len(variables.parallel_upload_limit))		{data.parallel_upload_limit	= variables.parallel_upload_limit;}	
			if (variables.decoder_bitrate_cap) {data.decoder_bitrate_cap = variables.decoder_bitrate_cap;}
			if (variables.decoder_buffer_size) {data.decoder_buffer_size = variables.decoder_buffer_size;}
			if (variables.one_pass) {data.one_pass = variables.one_pass;}
			if (variables.upscale) {data.upscale = variables.upscale;}
			if (variables.audio_constant_bitrate) {data.audio_constant_bitrate = variables.audio_constant_bitrate;}
			if (len(variables.aspect_mode))		{data.aspect_mode	= variables.aspect_mode;}
			
			if (not isNull(variables.notifications)) {
				data.notifications 	= variables.notifications.getData();
			}
			if (not isNull(variables.thumbnails)) {
				data.thumbnails 	= variables.thumbnails.getData();
			}
			if (not isNull(variables.watermarks)) {
				data.watermarks 	= variables.watermarks.getData();
			}			
			if (not isNull(variables.headers)) {
				data.headers 		= variables.headers;
			}
			return data;
		</cfscript>
	</cffunction>
	
</cfcomponent>