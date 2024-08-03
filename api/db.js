import mysql from "mysql2"

export const db = mysql.createConnection({
  host:"localhost",
  user:"sandesh",
  password: "$@nD3$#",
  database:"blog"
})
