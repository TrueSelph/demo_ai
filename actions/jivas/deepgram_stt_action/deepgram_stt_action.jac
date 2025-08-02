import base64;
import logging;
import traceback;
import requests;
import from logging { Logger }
import from jivas.agent.action.stt_action { STTAction }

node DeepgramSTTAction(STTAction) {
    # A speech action which integrates with the Deepgram speech to text and text to speech API.

    # set up logger
    static has logger: Logger = logging.getLogger(__name__);

    has model: str = 'nova-2'; # enhanced, nova, base
    has smart_format: bool = True;

    def invoke(audio_url: str) {
        # """
        # Convert an audio file from a URL to text using Deepgram API.

        # :param audio_url: URL of the audio file
        # :return: Transcription text
        # """

        if not self.api_key {
            return None;
        }

        transcript = None;

        # Prepare the headers with the API key
        headers = {
            "Authorization": f"Token {self.api_key}",
            "Content-Type": "application/json"
        };

        # Prepare the data payload
        data = {"url": audio_url};

        # Make the POST request to Deepgram API
        try  {
            response = requests.post(
                "https://api.deepgram.com/v1/listen",
                headers=headers, json=data, params={
                    'model': self.model,
                    'smart_format': str(self.smart_format).lower()
                }
            );
            response.raise_for_status();

            # Get the JSON response
            if (result := response.json()) {
                # Extract and return transcript text
                # Deepgram's response structure might differ, adjust based on actual API response
                transcript = result.get('results', {}).get('channels', [{}])[0].get(
                    'alternatives',
                    [{}]
                )[0].get(
                    'transcript',
                    ''
                );
            }

        } except requests.exceptions.HTTPError as e {
            self.logger.error(
                f"an exception occurred, {traceback.format_exc()}"
            );
        }

        return transcript;
    }

    def invoke_base64(audio_base64: str, audio_type: str="audio/mp3") {
        # """
        # Convert an audio file from a base64 string to text using Deepgram API.

        # :param audio_base64: Base64 representation of the audio file
        # :param audio_type: mimetype of the audio file
        # :return: Transcription text
        # """

        if not self.api_key {
            return None;
        }

        transcript = None;

        # Prepare the headers with the API key
        headers = {
            "Authorization": f"Token {self.api_key}",
            "Content-Type": audio_type
        };

        # Prepare the data payload
        data = base64.b64decode(audio_base64);

        # Make the POST request to Deepgram API
        try  {
            response = requests.post(
                "https://api.deepgram.com/v1/listen",
                headers=headers, data=data, params={
                    'model': self.model,
                    'smart_format': str(self.smart_format).lower()
                }
            );
            response.raise_for_status();

            # Get the JSON response
            if (result := response.json()) {
                # Extract and return transcript text
                # Deepgram's response structure might differ, adjust based on actual API response
                transcript = result.get('results', {}).get('channels', [{}])[0].get(
                    'alternatives',
                    [{}]
                )[0].get(
                    'transcript',
                    ''
                );
            }

        } except requests.exceptions.HTTPError as e {
            self.logger.error(
                f"an exception occurred, {traceback.format_exc()}"
            );
        }

        return transcript;
    }

    def invoke_file(audio_content: str, audio_type: str="audio/mp3") {
        # """
        # Use Deepgram API to transcribe an audio file.

        # :param audio_content: Content of the audio file
        # :param audio_type: mimetype of the audio file
        # :return: Transcription text and duration
        # """

        if not self.api_key {
            return None;
        }

        transcript = None;
        duration = 0;

        # Prepare the headers with the API key
        headers = {
            "Authorization": f"Token {self.api_key}",
            "Content-Type": audio_type
        };

        # Make the POST request to Deepgram API
        try  {
            response = requests.post(
                "https://api.deepgram.com/v1/listen",
                headers=headers, data=audio_content, params={
                    'model': self.model,
                    'smart_format': str(self.smart_format).lower()
                }
            );
            response.raise_for_status();

            # Get the JSON response
            if (result := response.json()) {
                # Extract and return transcript text
                # Deepgram's response structure might differ, adjust based on actual API response
                transcript = result.get('results', {}).get('channels', [{}])[0].get(
                    'alternatives',
                    [{}]
                )[0].get(
                    'transcript',
                    ''
                );

                duration = result.get("metadata", {}).get("duration", 0);
            }

        } except requests.exceptions.HTTPError as e {
            self.logger.error(
                f"an exception occurred, {traceback.format_exc()}"
            );
        }

        return {"transcript": transcript, "duration": duration};
    }

    def healthcheck() -> bool {

        if(not self.api_key){
            return {
                "status": False,
                "message": f"Deepgram API key is not set.",
                "severity": "error"
            };
        }
        if(not self.model) {
            return {
                "status": False,
                "message": f"Deepgram model is not set.",
                "severity": "error"
            };
        }

        try {
            url = "https://api.deepgram.com/v1/projects";
            headers = {"Authorization": f"Token {self.api_key}"};
            response = requests.get(url, headers=headers);
            if response.status_code == 200 {
                # Key is valid and operational
                return True;
            } else {
                # Key is invalid or non-operational
                return {
                    "status": False,
                    "message": f"Check Deepgram STT Action configuration: {response.text}",
                    "severity": "error"
                };
            }

        } except Exception as e {
            self.logger.error(f"An exception occurred in {self.label}:\n{traceback.format_exc()}\n");
            return {
                "status": False,
                "message": f"Check Deepgram STT Action configuration: {e}",
                "severity": "error"
            };
        }

        return {
            "status": False,
            "message": f"Check Deepgram STT Action configuration.",
            "severity": "error"
        };
    }
}
