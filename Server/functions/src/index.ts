import * as functions from 'firebase-functions';

import * as admin from 'firebase-admin';
import * as express from 'express';
import * as bodyParser from "body-parser";

admin.initializeApp(functions.config().firebase);

//const db = admin.firestore();

const app = express();
const main = express();

main.use("/api/v1/", app);
main.use(bodyParser.json());
main.use(bodyParser.urlencoded({extended: false}));

export const api = functions.https.onRequest(main);

//Greeting API
app.get("/greeting", (req, res) => {
	res.send("Greeting!");
})