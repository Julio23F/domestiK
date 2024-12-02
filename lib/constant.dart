// const baseURL = 'http://10.0.2.2:8000/api';
const baseURL = 'http://192.168.88.39:8000/api';
// const baseURL = 'https://domestik-api-production.up.railway.app/api';
// const baseURL = 'http://api-domestik.rf.gd/api';

// actuelle
// const baseURL = 'http://api-domestik.mooo.com/api';
// User
const loginURL = '$baseURL/login';
const registerURL = '$baseURL/register';
const logoutURL = '$baseURL/logout';
const userURL = '$baseURL/user';
const preference = '$baseURL/updateUserPreference';
const constUpdateUser = '$baseURL/updateUser';

//Tous les utilisateurs qui ne sont pas encore dans un foyer
const allUser = '$baseURL/allUser';
//Les membres qui sont déja dans le foyer
const allMembre = '$baseURL/foyer';
const addUsers = '$baseURL/foyer';
//activer ou désactiver un utilisateur
const activeOrUnable = '$baseURL/active';
const change_admin = '$baseURL/changeAdmin';
const remove_user = '$baseURL/removeUser';

// Foyer
const getFoyerURL = '$baseURL/foyer';
const createFoyerURL = '$baseURL/foyer';
const updateFoyerURL = '$baseURL/foyer';
const deleteFoyerURL = '$baseURL/foyer';

// Tache
const urlAllUserTache = '$baseURL/foyer';
const tache = '$baseURL/foyer';
const delete_tache = '$baseURL/deleteTache';

const historique = '$baseURL/historique';
const confirmer = '$baseURL/confirmer';

//Grouper
const groupe = '$baseURL/createGroupe';
const listGroupe = '$baseURL/getListGroupe';
const remove = '$baseURL/removeFromGroupe';
const deleteGroupe = '$baseURL/deleteGroupe';

// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';
