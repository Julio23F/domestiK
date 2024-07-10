import 'package:flutter/material.dart';

// const baseURL = 'http://10.0.2.2:8000/api';
const baseURL = 'http://192.168.88.25:8000/api';


// User
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';
const preference = baseURL + '/updateUserPreference';

//Tous les utilisateurs qui ne sont pas encore dans un foyer
const allUser = baseURL + '/allUser';
//Les membres qui sont déja dans le foyer
const allMembre = baseURL + '/foyer';
const addUsers = baseURL + '/foyer';
//activer ou désactiver un utilisateur
const activeOrUnable = baseURL + '/active';
const change_admin = baseURL + '/changeAdmin';
const remove_user = baseURL + '/removeUser';

// Foyer
const getFoyerURL = baseURL + '/foyer';
const createFoyerURL = baseURL + '/foyer';
const updateFoyerURL = baseURL + '/foyer';
const deleteFoyerURL = baseURL + '/foyer';

// Tache
const urlAllUserTache = baseURL + '/foyer';
const tache = baseURL + '/foyer';
const delete_tache = baseURL + '/deleteTache';

const historique = baseURL + '/historique';
const confirmer = baseURL + '/confirmer';

// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';






