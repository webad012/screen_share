class ScreenShare {
    constructor({
        divId, sendMethod
    }) {
        this.sendMethod = sendMethod;
        this.div = document.getElementById(divId);
        this.videoElem = null;
        this.imageElem = null;
        this.isSharingScreen = false;
        this.sharingIntervalId = null;
        this.displayMediaOptions = {
            video: {
                displaySurface: "window",
            },
            audio: false,
            // video: {
            //     displaySurface: "browser",
            // },
            // audio: {
            //     suppressLocalAudioPlayback: false,
            // },
            // preferCurrentTab: false,
            // selfBrowserSurface: "exclude",
            // systemAudio: "include",
            // surfaceSwitching: "include",
            // monitorTypeSurfaces: "include",
        };
        this.canvas = document.createElement('canvas');
    }

    async startCapture() {
        try {

            if(this.videoElem === null)
            {
                this.videoElem = document.createElement("video");
                this.videoElem.autoplay = true;
                this.div.appendChild(this.videoElem);
            }

            this.videoElem.srcObject =
                await navigator.mediaDevices.getDisplayMedia(this.displayMediaOptions);
            this.isSharingScreen = true;
            this.sharingIntervalId = setInterval(() => this.sendVideoData(), 100);

        } catch (err) {
            console.error(err);
        }
    }

    stopCapture() {
        this.isSharingScreen = false;
        clearInterval(this.sharingIntervalId);
        let tracks = this.videoElem.srcObject.getTracks();

        tracks.forEach((track) => track.stop());
        this.videoElem.srcObject = null;
    }

    sendVideoData() {
        if(this.isSharingScreen !== true)
        {
            return;
        }

        this.canvas.width = 1920;
        this.canvas.height = 1080;

        let ctx = this.canvas.getContext('2d');
        ctx.drawImage( this.videoElem, 0, 0, this.canvas.width, this.canvas.height );

        const image = this.canvas.toDataURL('image/jpeg');
        this.sendMethod(image);
    }

    receiveImageData(imageData) {
        if(this.isSharingScreen === true)
        {
            return;
        }

        if(this.imageElem === null)
        {
            this.imageElem = document.createElement("img");
            this.div.appendChild(this.imageElem);
        }
        this.imageElem.src = imageData;
    }
}