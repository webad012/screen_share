function onLoad() {
    const logElem = document.getElementById("log");
    const startElem = document.getElementById("start");
    const stopElem = document.getElementById("stop");

    // Set event listeners for the start and stop buttons
    startElem.addEventListener(
        "click",
        (evt) => {
            logElem.innerHTML = "";
            screenShare.startCapture();
        },
        false,
    );

    stopElem.addEventListener(
        "click",
        (evt) => {
            screenShare.stopCapture();
        },
        false,
    );

    console.log = (msg) => (logElem.textContent = `${logElem.textContent}\n${msg}`);
    console.error = (msg) => (logElem.textContent = `${logElem.textContent}\nError: ${msg}`);

    /// websocket
    let wsconn = new WebSocket('ws://localhost:8081');
    wsconn.onopen = function(e) {
        console.log("websocket onnection established!");
    };
    wsconn.onmessage = function(messageEvent) {
        screenShare.receiveImageData(messageEvent.data);
    };

    let screenShare = new ScreenShare({
        divId: "screenShare", sendMethod: function(wsdata) {
            wsconn.send(wsdata);
        }
    });
}