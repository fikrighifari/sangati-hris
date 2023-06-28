const keyGoogleMap = "AIzaSyBIhOYoxLJQqkUA5fQSr60JkPit891uc14";

//--------Local API
// const baseAPIUrl = "http://192.168.10.88/hris-office/api/v1/";
// const baseAPIUrlImage = "http://192.168.10.88/hris-office/api/v1/";

//--------Live API
const baseAPIUrl = "https://develop.apijlantahdev.xyz:8443/api/v1/";
const baseAPIUrlImage = "https://develop.apijlantahdev.xyz:8443/api/v1/";

const postAPILogin = "${baseAPIUrl}auth";
const postAPIRegister = "${baseAPIUrl}auth/register";

const getAPIHome = "${baseAPIUrl}home";
const getAPIHistoryDetail = "${baseAPIUrl}attendance/detail";
const postAPIPresensiIn = "${baseAPIUrl}attendance/clock_in";
const postAPIPresensiOut = "${baseAPIUrl}attendance/clock_out";

const getAPIProfile = '$baseAPIUrl/profile/me';
const getAPIShift = "${baseAPIUrl}profile/shift";
const postAPIVerifikasi = "${baseAPIUrl}profile/verification";
const getAPIAttendanceHistory = "${baseAPIUrl}profile/attendance";
