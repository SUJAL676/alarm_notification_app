const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendAlarmNotification = functions.https.onCall(async (data, context) => {
  const type = data.type;

  const message = {
    topic: "all_devices",
    data: {
      type: type,
    },
    android: {
      priority: "high",
      notification: {
        sound: "alarm",
      },
    },
    apns: {
      payload: {
        aps: {
          sound: "default",
          contentAvailable: true,
        },
      },
    },
  };

  await admin.messaging().send(message);

  return { success: true };
});