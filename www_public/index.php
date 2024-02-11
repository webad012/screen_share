<?php
header('Permissions-Policy: display-capture=(self)');
?>
<html>
  <head>
    <script src="screenShare.js"></script>
    <script src="lib.js"></script>
    <link rel="stylesheet" href="lib.css">
  </head>
  <body onload="onLoad()">
      <p>
        This example shows you the contents of the selected part of your display.
        Click the Start Capture button to begin. Content is shared to other (WS) connections
      <p>
        <button id="start">Start Capture</button>
        &nbsp;
        <button id="stop">Stop Capture</button>
      </p>
      
      <div id="screenShare"></div>
      <br />
      
      <strong>Log:</strong>
      <br />
      <pre id="log"></pre>
  </body>
</html>