importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyAoI5fsV_vRHrJfLSHT0U13Cp-bzOc9TMY",
  authDomain: "operators-5f1b2.firebaseapp.com",
  projectId: "operators-5f1b2",
  storageBucket: "operators-5f1b2.appspot.com",
  messagingSenderId: "562136210693",
  appId: "1:562136210693:web:0038f5c399a7402433eb6c",
  databaseURL: "https://operators-5f1b2.firebaseio.com",
});

const messaging = firebase.messaging();
