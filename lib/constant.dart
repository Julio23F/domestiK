import 'package:flutter/material.dart';

const baseURL = 'http://10.0.2.2:8000/api';

// User
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';

//Tous les utilisateurs qui ne sont pas encore dans un foyer
const allUser = baseURL + '/allUser';

// Foyer
const getFoyerURL = baseURL + '/foyer';
const createFoyerURL = baseURL + '/foyer';
const updateFoyerURL = baseURL + '/foyer';
const deleteFoyerURL = baseURL + '/foyer';

// Tache
const urlAllUserTache = baseURL + '/foyer';
const tache = baseURL + '/foyer';


// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';






