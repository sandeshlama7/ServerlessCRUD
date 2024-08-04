import axios from "axios"

const api = axios.create({
//   baseURL: process.env.API_BASE_URL,
    baseURL: "http://localhost:8800",
});

export default axios;
