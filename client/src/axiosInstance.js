import axios from "axios";

const axiosInstance = axios.create({
  baseURL: process.env.REACT_APP_BASE_URL,
    // baseURL: "http://localhost:8800"
});

export default axiosInstance;
