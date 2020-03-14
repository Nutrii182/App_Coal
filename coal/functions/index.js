const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

const dbReference = admin.firestore();

exports.notifyStatus = functions.firestore.document('Citas/{idCita}').onUpdate(async (change, context) => {

    const beforeDoc = change.before.data();
    const afterDoc = change.after.data();

    const token = beforeDoc.Token;

    console.log(beforeDoc.Proxima);
    console.log(afterDoc.Proxima);

    if (afterDoc.Estado === 'Aceptada' && afterDoc.Proxima === beforeDoc.Proxima) {

        const payload = {
            notification: {
                title: "Cita Aceptada",
                body: "Su cita solicitada a las " + afterDoc.Hora + " fue aceptada.",
                click_action: "FLUTTER_NOTIFICATION_CLICK"
            }
        }
        return admin.messaging().sendToDevice(token, payload);

    }

    if (afterDoc.Estado === 'Rechazada' && afterDoc.Proxima === beforeDoc.Proxima) {
        const payload = {
            notification: {
                title: "Cita Rechazada",
                body: "Su cita solicitada a las " + afterDoc.Hora + " fue rechazada por motivos personales u/o otras razones, una disculpa de parte COAL",
                click_action: "FLUTTER_NOTIFICATION_CLICK"
            }
        }
        return admin.messaging().sendToDevice(token, payload);
    }

    return null;
});