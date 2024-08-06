import React from "react";
import { useEffect } from "react";
import { useState } from "react";
import { Link } from "react-router-dom";
import axios from "../axiosInstance";

const Books = () => {
  const [books, setBooks] = useState([]);

  const fetchAllBooks = async () => {
    try {
      const res = await axios.get("/books");
      const transformedBooks = res.data.map((bookData) => ({
        id: bookData[0],
        title: bookData[1],
        desc: bookData[2],
        price: bookData[3],
        cover: bookData[4]
      }));
      setBooks(transformedBooks);
    } catch (err) {
      console.log(err);
    }
  };
  useEffect(() => {
    fetchAllBooks();
  }, []);

  const handleDelete = async (id) => {
    try {
      await axios.delete(`/books/${id}`);
      setBooks(prevBooks => prevBooks.filter(book => book.id !== id));
    } catch (err) {
      console.log(err);
    }
  };

  return (
    <div>
      <h1>Lama Book Shop</h1>
      <div className="books">
        {books.map((book) => (
          <div key={book.id} className="book">
            <img src={book.cover} alt="" />
            <h2>{book.title}</h2>
            <p>{book.desc}</p>
            <span>${book.price}</span>
            <button className="delete" onClick={() => handleDelete(book.id)}>Delete</button>
            <button className="update">
              <Link
                to={`/update/${book.id}`}
                style={{ color: "inherit", textDecoration: "none" }}
              >
                Update
              </Link>
            </button>
          </div>
        ))}
      </div>

      <button className="addHome">
        <Link to="/add" style={{ color: "inherit", textDecoration: "none" }}>
          Add new book
        </Link>
      </button>
    </div>
  );
};

export default Books;
