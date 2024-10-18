# threema2html
Build HTML-Page from iOS Threema Chat-Export

- Testet on Ubuntu 24.04.1 lTS
- Will not work on macOS (you'll need GnuGrep)

Procedure:

1. Chat: ‘Export chat’, ‘With media’
2. Download the ZIP to your computer (e.g. via iCloud Drive) and unzip it
3. Put Script in unpacked directory
4. Call script and redirect output: threema2html.sh messages.txt > messages.html

For your information:

- I created this with ChatGPT (it's crazy what that thing can do) and then refined it by hand.
- The Threema export is currently not 100% consistent, especially if the chat covers a very long period of time. The script copes with most of the problems.
- Images are displayed with preview size, videos should also have a preview, everything else is displayed as a simple link.
- Visually, the output is based on WhatsApp, which I found nicer. Otherwise, this can be customised in the CSS part of the script.
- Tested with Threema for iOS in version 6.3.1 (6342). Script tested on Ubuntu 24.04.1 LTS. Chrome can display the generated page without any problems.
- You are welcome to adapt and correct the script. You are also welcome to redistribute it, perhaps with a reference to the thread here.

Known problems:

- It happens that images are displayed as a file link, then Threema has exported the image with the tag ‘file’. I have adjusted the script so that it partially corrects this.
- There could be problems if a chat text contains line breaks.
- Occurred with me: if you open the HTML with Safari, Safari stops loading images at some point (for very long chats with many images).

Usual disclaimer: I give no guarantee on the error-free function!
