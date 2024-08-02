/// <reference types="howler"/>
/// <reference types="jquery"/>

'use strict';

var player = null;
var serial = '6039';
var keys = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

for (var i = 0; i < 4; i++) {
  serial += keys.charAt(Math.floor(Math.random() * keys.length));
}

setInterval(() => {
  const now = new Date();
  let offset = now.getTimezoneOffset() / -60;
  now.setTime(now.getTime() + offset * 60);
  if (
    now.getTimezoneOffset() <
    Math.max(
      new Date(now.getFullYear(), 0, 1).getTimezoneOffset(),
      new Date(now.getFullYear(), 6, 1).getTimezoneOffset(),
    )
  ) {
    offset += 1;
  }
  const iso = new Date(now.getTime() + offset * 36e5).toISOString();
  $('#date').text(
    `${iso.substring(0, 10)} ${iso.substring(11, 19)} ${offset < 0 ? '-' : '+'}${Math.abs(offset)
      .toString()
      .padEnd(3, '0')
      .padStart(4, '0')}`,
  );
}, 1e3);

$(function() {
  window.addEventListener('message', function(event) {
    if (event.data.type == "on") {
      $('#ui').css('display', 'block');
    }
    else if (event.data.type == "off") {
      $('#ui').css('display', 'none');
    }
    else if (event.data.type == "playAudio") {
      if (player != null) {
        player.pause();
      }
      let audio = null
      event.data.audio ? audio = "./BodyCamStart.wav" : audio = "./BodyCamStop.wav"
      player = new Howl({ src: [audio]});
      player.volume(1.0);
      player.play();
    }
  });
});