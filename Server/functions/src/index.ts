import * as functions from 'firebase-functions';

import * as admin from 'firebase-admin';
import * as express from 'express';
import * as bodyParser from "body-parser";
import {RequestHandler} from "./request-handler";

admin.initializeApp(functions.config().firebase);

const db = admin.firestore();

const app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));


const requestHandler = new RequestHandler();

app.get("/genres", (req, res) => {
	requestHandler.getAllGenres(db).then(doc => res.status(200).send(doc)).catch(() => console.log("Error"));
});

app.get("/movies", (req, res) => {
	requestHandler.getMovies(db, req.query).then(doc => res.status(200).send(doc)).catch(() => console.log("Error"));
});

app.get("/locations", (req, res) => {
	requestHandler.getAllLocations(db).then(doc => res.status(200).send(doc)).catch(() => console.log("Error"));
});

app.post("/login", (req, res) => {
	requestHandler.login(db, req.body).then(doc => res.status(200).send(doc)).catch(() => "abcs");
});

export const api = functions.https.onRequest(app);