import 'package:flutter/material.dart';

const baseURL = 'http://10.0.2.2:8000/api';

// User
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';

// Foyer
const getFoyerURL = baseURL + '/foyer';
const createFoyerURL = baseURL + '/foyer';
const updateFoyerURL = baseURL + '/foyer';
const deleteFoyerURL = baseURL + '/foyer';

// Tache
const getAllUserTache = baseURL + '/foyer';


// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';






