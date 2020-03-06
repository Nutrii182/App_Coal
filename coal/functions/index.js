const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

const dbReference = admin.firestore();

exports.sendNotification = functions.firestore.document('Citas/{idCita}').onUpdate(async (change, context) => {

    const upDoc = change.after.data();
    const token = upDoc.Token;

    if (upDoc.Estado === 'Aceptada') {
        
        const payload = {
            notification: {
                title: "Cita Aceptada",
                body: "Su cita solicitada a las " + upDoc.Hora + " fue aceptada.",
                click_action: "FLUTTER_NOTIFICATION_CLICK"
            }
        }
        return admin.messaging().sendToDevice(token, payload);

    } else {

        const payload = {
            notification: {
                title: "Cita Rechazada",
                body: "Su cita solicitada a las " + upDoc.Hora + " fue rechazada por motivos personales u/o otras razones, una disculpa de parte COAL",
                click_action: "FLUTTER_NOTIFICATION_CLICK"
            }
        }
        return admin.messaging().sendToDevice(token, payload);
    }
});