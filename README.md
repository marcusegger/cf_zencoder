# cf_zencoder

## Introduction
This is a Coldfusion implementation for the Zencoder API (http://www.zencoder.com). This version is based on the existing but not maintained project by Todd Schlomer (http://zencoder.riaforge.org/)

## Added / modified
Since Todd Schlomer's Version 1.0.0 (April 9, 2011 5:53 AM) you'll get the following changes/enhancements

### API BASE URL: 
* Default changed to Zencoder API Version 2: https://app.zencoder.com/api/v2. However, if you like to use API version 1 please use https://app.zencoder.com/api

### New method getOutputDetails() 
* Method for getting output details for a transcoded Zencoder job (please note: available only in API version 2 or greater)

### Method buildMediaDetailsFromJobCreation()
* reloacted to Zencoder.cfc to keep your calling template clean

### ZencoderOutput.cfc: 
* new Options added for: size, device_profile, h264_profile, h264_level, h264_reference_frames, parallel_upload_limit, decoder_bitrate_cap, decoder_buffer_size, one_pass, audio_constant_bitrate, upscale, aspect_mode

### Zencoder.cfc 
* Options added for: strictMode, privateMode, pass_through

### ZencoderWatermarks.cfc 
* Component added for watermark(s) support via Zencoder API. You can create Watermarks dynamically