// functions/index.js

const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Inisialisasi Firebase Admin SDK
admin.initializeApp();

/**
 * Cloud Function yang bisa dipanggil dari aplikasi Flutter (onCall).
 * Tugasnya adalah membuat user anonim baru dan mengembalikan
 * custom token untuk login.
 */
exports.createAnonymousToken = functions.https.onCall(async (data, context) => {
  try {
    // Membuat user anonim baru di Firebase Auth menggunakan Admin SDK
    const userRecord = await admin.auth().createUser({});
    const uid = userRecord.uid;

    // Membuat custom token untuk UID yang baru saja dibuat
    const customToken = await admin.auth().createCustomToken(uid);

    // Mencatat log di Firebase Console (baik untuk debugging)
    functions.logger.info(`Anonymous token created for UID: ${uid}`);
    
    // Mengembalikan token dan UID ke aplikasi Flutter
    return { token: customToken, uid: uid };

  } catch (error) {
    functions.logger.error("Error creating anonymous token:", error);
    // Melemparkan error yang bisa ditangkap oleh aplikasi Flutter
    throw new functions.https.HttpsError(
      "internal",
      "Gagal membuat token anonim.",
      error
    );
  }
});